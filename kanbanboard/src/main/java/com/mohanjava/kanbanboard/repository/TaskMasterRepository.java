package com.mohanjava.kanbanboard.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.mohanjava.kanbanboard.model.TaskMaster;

public interface TaskMasterRepository extends JpaRepository<TaskMaster, Integer> {

	@Query("SELECT tm FROM TaskMaster tm WHERE tm.recordStatus = 'Active'")
    public List<TaskMaster> findAllActiveTasks();
	
}
