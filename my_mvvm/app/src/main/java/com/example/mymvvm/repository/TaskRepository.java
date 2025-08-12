package com.example.mymvvm.repository;

import java.util.ArrayList;
import java.util.List;
import kotlinx.coroutines.scheduling.Task;

public class TaskRepository {
    private List<Task> tasks = new ArrayList<>();

    public List<Task> getTasks() {
        return tasks;
    }

    public void addTask(Task task) {
        tasks.add(0, task);
    }

    public void removeTask(int position) {
        if (position >= 0 && position < tasks.size()) {
            tasks.remove(position);
        }
    }
}
