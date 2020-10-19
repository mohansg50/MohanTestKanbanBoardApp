<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>Kanban Board</title>

<!--  JS -->
<script src="webjars/jquery/3.5.1/jquery.min.js" type="text/javascript"></script>
<script src="webjars/jquery-ui/1.12.1/jquery-ui.js" type="text/javascript"></script>
<script src="webjars/bootstrap/4.4.1/js/bootstrap.min.js" type="text/javascript"></script>


<!--  CSS -->
<link rel="stylesheet" type="text/css" href="webjars/bootstrap/4.4.1/css/bootstrap.min.css" />


<style type="text/css">
.my-task-item {
	/*display: block;*/
	padding: 10px;
	background-color: #DCDCDC;
	border: 1px solid #A9A9A9;
	margin: 6px;
	z-index: 100;
}

.my-task-item:hover {
	border: 1px solid #ff0;
}

.my-droppable {
	
}

.my-droppable ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	width: 100%;
}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		$(".my-task-item").draggable({
			'opacity' : '0.5',
			'revert' : false,
			'cursor' : 'pointer',
		});

		$(".my-droppable").droppable({
			drop : function(event, ui) {
				var taskMasterID = ui.draggable.prop('id');
				var taskCategory = $(this).prop("id");

				processDropAction(taskMasterID, taskCategory);
			}
		});

		getTaskList();

	});

	function processDropAction(taskMasterID, taskCategory) {
		var json = {
			'taskMasterID' : taskMasterID,
			'taskCategory' : taskCategory
		};

		$.ajax({
			type : "POST",
			url : "processTaskMasterDropAction",
			contentType : 'application/json',
			data : JSON.stringify(json)
		}).done(function() {
			getTaskList();
		});
	}

	function createNewTask() {

		var taskName = $.trim($('#taskName').val());

		if (taskName.length == 0) {
			alert("Enter task name");
			$('#taskName').focus();
			return false;
		}

		var json = {
			'taskName' : taskName
		};

		$.ajax({
			type : "POST",
			url : "createTaskMaster",
			contentType : 'application/json',
			data : JSON.stringify(json)
		}).done(function() {

			$('#taskName').val('');

			getTaskList();
		});
	}

	function getTaskList() {

		var json = {};

		$.ajax({
			type : "POST",
			url : "getTaskList",
			contentType : 'application/json',
			data : JSON.stringify(json)
		}).done(function(resultList) {
			var arr = resultList;
			displayBoard(arr);
		});
	}

	function displayBoard(arr) {

		var c = arr.length;

		$('#backlogList').empty();
		$('#todoList').empty();
		$('#ongoingList').empty();
		$('#doneList').empty();

		for (var i = 0; i < c; i++) {

			var obj = arr[i];

			var str = "<li id='"+obj.taskMasterID+"' class='my-task-item' data-taskname='"+obj.taskName+"' data-taskcat='"+obj.taskCategory+"'>"
					+ obj.taskName + "</li>";

			if (obj.taskCategory == 'Backlog') {
				$('#backlogList').append(str);
			} else if (obj.taskCategory == 'To Do') {
				$('#todoList').append(str);
			} else if (obj.taskCategory == 'Ongoing') {
				$('#ongoingList').append(str);
			} else if (obj.taskCategory == 'Done') {
				$('#doneList').append(str);
			}
		}

		$(".my-task-item").draggable({
			'opacity' : '0.5',
			'revert' : false,
			'cursor' : 'pointer',
		});

		$(".my-task-item").click(function() {
			var id = $(this).prop('id');
			var taskName = $(this).data('taskname');
			var taskCat = $(this).data('taskcat');

			$('#selectedTaskName').data('taskmasterid', id);
			$('#selectedTaskName').data('taskcat', taskCat);
			$('#selectedTaskName').val(taskName);

		});
	}

	function deleteTask() {

		var id = $('#selectedTaskName').data('taskmasterid');

		if (id.length == 0) {
			alert("Select a task to delete.");
			return false;
		}

		if (!confirm('Are you sure, you want to delete this task?')) {
			return false;
		}

		var json = {
			'taskMasterID' : id
		};

		$.ajax({
			type : "POST",
			url : "deleteTask",
			contentType : 'application/json',
			data : JSON.stringify(json)
		}).done(function(resultList) {
			
			$('#selectedTaskName').val('');
			$('#selectedTaskName').data('taskmasterid','');
			$('#selectedTaskName').data('taskcat','');
			
			getTaskList();
		});
	}

	function moveTask(taskMoveDirection) {

		var id = $('#selectedTaskName').data('taskmasterid');
		var taskCatCurrent = $('#selectedTaskName').data('taskcat');

		if (id) {
			//continue
		} else {
			alert("Select a task to move.");
			return false;
		}

		var taskCatNew = "";

		if (taskMoveDirection == "MOVEBACK") {
			if (taskCatCurrent == 'Backlog') {
				alert("Can not move backward");
				return false;
			} else if (taskCatCurrent == 'To Do') {
				taskCatNew = "Backlog";
			} else if (taskCatCurrent == 'Ongoing') {
				taskCatNew = "To Do";
			} else if (taskCatCurrent == 'Done') {
				taskCatNew = "Ongoing";
			}

		} else if (taskMoveDirection == "MOVEFORWARD") {
			if (taskCatCurrent == 'Backlog') {
				taskCatNew = "To Do";
			} else if (taskCatCurrent == 'To Do') {
				taskCatNew = "Ongoing";
			} else if (taskCatCurrent == 'Ongoing') {
				taskCatNew = "Done";
			} else if (taskCatCurrent == 'Done') {
				alert("Can not move forward");
				return false;
			}
		}

		var json = {
			'taskMasterID' : id,
			'taskCategory' : taskCatNew
		};

		$.ajax({
			type : "POST",
			url : "moveTask",
			contentType : 'application/json',
			data : JSON.stringify(json)
		}).done(function(resultList) {
			$('#selectedTaskName').val('');
			$('#selectedTaskName').data('taskmasterid','');
			$('#selectedTaskName').data('taskcat','');
			
			getTaskList();
		});
	}
</script>

</head>
<body>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12 text-center">
				<span class="alert-msg">${message}</span>
			</div>
		</div>

		<div class="row">
			<div class="col-md-12">&nbsp;</div>
		</div>

		<div class="row">
			<div class="col-md-6 col-sm-6">
				<form:form action="createTask" method="post" modelAttribute="taskMaster">
					<div class="input-group mb-3">
						<div class="input-group-prepend">
							<span class="input-group-text" id=""><b>Create New Task:</b></span>
						</div>
						<form:input class="form-control" id='taskName' path="taskName" value="" placeholder="New task name" aria-label="New task name"
							aria-describedby="basic-addon2" />
						<div class="input-group-append">
							<button class="btn btn-success" type="button" onclick="createNewTask();">Create</button>
						</div>
					</div>
				</form:form>
			</div>
		</div>


		<div class="row">
			<div class="col-md-6 col-sm-6">
				<div class="input-group mb-3">
					<input type="text" class="form-control" id="selectedTaskName" value="" placeholder="Click on an existing task"
						aria-label="Click on an existing task" aria-describedby="basic-addon2" />

					<div class="input-group-append">
						<button class="btn btn-outline-secondary" type="button" onclick="moveTask('MOVEBACK');">Move Back</button>
						<button class="btn btn-outline-secondary" type="button" onclick="moveTask('MOVEFORWARD');">Move Forward</button>
						<button class="btn btn-danger" type="button" onclick='deleteTask();'>Delete</button>
					</div>
				</div>
			</div>
		</div>


		<div class="card-group">
			<div class="card">
				<div class="card-header text-center font-weight-bold">Backlog</div>
				<div class="card-body my-droppable" id="Backlog">
					<ul id="backlogList"></ul>
				</div>
			</div>

			<div class="card">
				<div class="card-header text-center font-weight-bold">To Do</div>
				<div class="card-body my-droppable" id="To Do">
					<ul id="todoList"></ul>
				</div>
			</div>

			<div class="card">
				<div class="card-header text-center font-weight-bold">Ongoing</div>
				<div class="card-body my-droppable" id="Ongoing">
					<ul id="ongoingList"></ul>
				</div>
			</div>
			<div class="card">
				<div class="card-header  bg-success text-center font-weight-bold">Done</div>
				<div class="card-body my-droppable" id="Done">
					<ul id="doneList"></ul>
				</div>

			</div>
		</div>

		<div id="root"></div>


		<!--  END -->
	</div>

</body>
</html>