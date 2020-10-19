package com.mohanjava.kanbanboard.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.springframework.lang.NonNull;

//@Data
//@NoArgsConstructor
//@RequiredArgsConstructor
@Entity
@Table(name = "task_master")
public class TaskMaster implements Serializable {

	private static final long serialVersionUID = 2146115829525822633L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "task_master_id")
	private int taskMasterID;

	@NonNull
	// @Column(name = "task_name", nullable = false, length = 200, unique = true)
	@Column(name = "task_name", nullable = false, length = 200)
	private String taskName;

	@NonNull
	@Column(name = "task_category", nullable = false, length = 45)
	private String taskCategory;

	@NonNull
	@Column(name = "record_status", nullable = false, length = 45)
	private String recordStatus;

	public int getTaskMasterID() {
		return taskMasterID;
	}

	public void setTaskMasterID(int taskMasterID) {
		this.taskMasterID = taskMasterID;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public String getTaskCategory() {
		return this.taskCategory;
	}

	public void setTaskCategory(String taskCategory) {
		this.taskCategory = taskCategory;
	}

	public String getRecordStatus() {
		return recordStatus;
	}

	public void setRecordStatus(String recordStatus) {
		this.recordStatus = recordStatus;
	}

	@Override
	public String toString() {
		return "TaskMaster [taskMasterID=" + taskMasterID + ", taskName=" + taskName + ", taskCategory=" + taskCategory
				+ ", recordStatus=" + recordStatus + "]";
	}

	
	
	
	
}
