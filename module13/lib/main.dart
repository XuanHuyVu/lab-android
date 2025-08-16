import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:permission_handler/permission_handler.dart';

// Service với permission handling mạnh mẽ
class CameraServiceWithPermission {
  static final ImagePicker _picker = ImagePicker();

  // Kiểm tra và yêu cầu quyền camera
  static Future<bool> _requestCameraPermission() async {
    try {
      PermissionStatus status = await Permission.camera.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        status = await Permission.camera.request();
        return status.isGranted;
      }

      if (status.isPermanentlyDenied) {
        // Hiển thị dialog yêu cầu mở settings
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('Error checking camera permission: $e');
      return false;
    }
  }

  // Kiểm tra và yêu cầu quyền storage
  static Future<bool> _requestStoragePermission() async {
    try {
      // Với Android 13+ (API 33+), không cần WRITE_EXTERNAL_STORAGE
      if (Platform.isAndroid) {
        // Chỉ cần READ_EXTERNAL_STORAGE cho gallery
        PermissionStatus status = await Permission.storage.status;

        if (status.isGranted) {
          return true;
        }

        if (status.isDenied) {
          status = await Permission.storage.request();
          return status.isGranted;
        }

        return false;
      }

      // iOS không cần permission đặc biệt cho gallery
      return true;
    } catch (e) {
      debugPrint('Error checking storage permission: $e');
      return true; // Fallback to true for iOS
    }
  }

  // Chụp ảnh với permission check
  static Future<File?> captureFromCamera() async {
    try {
      // Kiểm tra permission trước
      bool hasCameraPermission = await _requestCameraPermission();
      if (!hasCameraPermission) {
        throw CameraPermissionException('Camera permission is required to take photos');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.rear,
      );

      return image != null ? File(image.path) : null;
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied') {
        throw CameraPermissionException('Camera access denied. Please enable camera permission in device settings.');
      } else if (e.code == 'photo_access_denied') {
        throw CameraPermissionException('Photo access denied. Please enable photo permission in device settings.');
      }
      throw CameraException('Failed to capture image: ${e.message}');
    } catch (e) {
      if (e is CameraPermissionException) {
        rethrow;
      }
      throw CameraException('Unexpected error: $e');
    }
  }

  // Lấy ảnh từ gallery với permission check
  static Future<File?> pickFromGallery() async {
    try {
      // Kiểm tra permission trước
      bool hasStoragePermission = await _requestStoragePermission();
      if (!hasStoragePermission) {
        throw CameraPermissionException('Storage permission is required to access gallery');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      return image != null ? File(image.path) : null;
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        throw CameraPermissionException('Gallery access denied. Please enable photo permission in device settings.');
      }
      throw CameraException('Failed to pick image: ${e.message}');
    } catch (e) {
      if (e is CameraPermissionException) {
        rethrow;
      }
      throw CameraException('Unexpected error: $e');
    }
  }

  // Lấy nhiều ảnh
  static Future<List<File>> pickMultipleFromGallery() async {
    try {
      bool hasStoragePermission = await _requestStoragePermission();
      if (!hasStoragePermission) {
        throw CameraPermissionException('Storage permission is required to access gallery');
      }

      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      if (e is CameraPermissionException) {
        rethrow;
      }
      throw CameraException('Failed to pick multiple images: $e');
    }
  }

  // Mở app settings
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

// Custom Exceptions
class CameraException implements Exception {
  final String message;
  CameraException(this.message);
  @override
  String toString() => 'CameraException: $message';
}

class CameraPermissionException implements Exception {
  final String message;
  CameraPermissionException(this.message);
  @override
  String toString() => 'CameraPermissionException: $message';
}

// Widget với permission handling UI
class CameraWithPermissionDemo extends StatefulWidget {
  const CameraWithPermissionDemo({super.key});

  @override
  State<CameraWithPermissionDemo> createState() => _CameraWithPermissionDemoState();
}

class _CameraWithPermissionDemoState extends State<CameraWithPermissionDemo> {
  File? _selectedImage;
  List<File> _multipleImages = [];
  bool _isLoading = false;

  // Hiển thị dialog permission denied
  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Permission Required'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            const Text(
              'To use this feature, please:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Go to App Settings'),
            const Text('2. Enable required permissions'),
            const Text('3. Return to the app'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Hiển thị dialog chọn source
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSourceOption(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  subtitle: 'Take a new photo',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _captureImage();
                  },
                ),
                const SizedBox(height: 12),
                _buildSourceOption(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  subtitle: 'Choose from gallery',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                const SizedBox(height: 12),
                _buildSourceOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Multiple Images',
                  subtitle: 'Select multiple photos',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _pickMultipleImages();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  // Chụp ảnh với error handling
  Future<void> _captureImage() async {
    setState(() => _isLoading = true);
    try {
      final File? image = await CameraServiceWithPermission.captureFromCamera();
      if (image != null) {
        setState(() => _selectedImage = image);
        _showSnackBar('Image captured successfully', Colors.green);
      }
    } on CameraPermissionException catch (e) {
      _showPermissionDialog(e.message);
    } on CameraException catch (e) {
      _showErrorDialog(e.message);
    } catch (e) {
      _showErrorDialog('Unexpected error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Chọn ảnh với error handling
  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    try {
      final File? image = await CameraServiceWithPermission.pickFromGallery();
      if (image != null) {
        setState(() => _selectedImage = image);
        _showSnackBar('Image selected successfully', Colors.green);
      }
    } on CameraPermissionException catch (e) {
      _showPermissionDialog(e.message);
    } on CameraException catch (e) {
      _showErrorDialog(e.message);
    } catch (e) {
      _showErrorDialog('Unexpected error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Chọn nhiều ảnh
  Future<void> _pickMultipleImages() async {
    setState(() => _isLoading = true);
    try {
      final List<File> images = await CameraServiceWithPermission.pickMultipleFromGallery();
      if (images.isNotEmpty) {
        setState(() {
          _multipleImages = images;
          _selectedImage = images.first;
        });
        _showSnackBar('${images.length} images selected', Colors.green);
      }
    } on CameraPermissionException catch (e) {
      _showPermissionDialog(e.message);
    } on CameraException catch (e) {
      _showErrorDialog(e.message);
    } catch (e) {
      _showErrorDialog('Unexpected error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Hiển thị ảnh fullscreen
  void _showImageFullScreen(File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Full Image'),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          body: PhotoView(
            imageProvider: FileImage(imageFile),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3.0,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Camera & Gallery'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => openAppSettings(),
            tooltip: 'App Settings',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing...'),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Permission info card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.security, size: 32, color: Colors.blue),
                    const SizedBox(height: 8),
                    const Text(
                      'Permission Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Camera and storage permissions are required for this app to function properly.',
                      style: TextStyle(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Select button
            ElevatedButton(
              onPressed: _showImageSourceDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo),
                  SizedBox(width: 8),
                  Text('Select Image', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Image display
            if (_selectedImage != null) ...[
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showImageFullScreen(_selectedImage!),
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.zoom_in,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Tap to zoom',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Image loaded successfully',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Multiple images grid
            if (_multipleImages.isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Images (${_multipleImages.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _multipleImages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _showImageFullScreen(_multipleImages[index]),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(_multipleImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withValues(alpha: 0.1),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.zoom_in,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (_selectedImage == null && _multipleImages.isEmpty)
              Card(
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(32),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No image selected',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Use the button above to select images',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Main app
class CameraPermissionApp extends StatelessWidget {
  const CameraPermissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera with Permissions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CameraWithPermissionDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(const CameraPermissionApp());
}