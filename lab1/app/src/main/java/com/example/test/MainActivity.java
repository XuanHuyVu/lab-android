package com.example.test;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.widget.*;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    EditText edtA, edtB, edtC;
    Button btncong;
    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Enable edge-to-edge mode
        EdgeToEdge.enable(this);

        // Set up the UI elements
        edtA = findViewById(R.id.edtA);
        edtB = findViewById(R.id.edtB);
        edtC = findViewById(R.id.edtC);
        btncong = findViewById(R.id.btncong);

        // Handle button click
        btncong.setOnClickListener(view -> {
            String a = edtA.getText().toString();
            String b = edtB.getText().toString();
            String c = edtC.getText().toString();

            // Perform addition and display result
            try {
                int sum = Integer.parseInt(a) + Integer.parseInt(b) + Integer.parseInt(c);
                Toast.makeText(MainActivity.this, "Sum: " + sum, Toast.LENGTH_SHORT).show();
            } catch (NumberFormatException e) {
                Toast.makeText(MainActivity.this, "Please enter valid numbers", Toast.LENGTH_SHORT).show();
            }
        });
    }
}