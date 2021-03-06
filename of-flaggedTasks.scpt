JsOsaDAS1.001.00bplist00�Vscript_�of = Application('OmniFocus');

doc = of.defaultDocument;

getTasks();

function getTasks(){
	var today = new Date();
	dueDate = new Date(today.setDate(today.getDate()+7));
	taskList = [];
	flattenedTasks = doc.flattenedTasks.whose({_or: [
		{completed: false, flagged: false, blocked: false, dueDate: {"<":dueDate}},
		{completed: false, flagged: true, blocked: false},
		{completed: false, flagged: false, blocked: false , _match: [ObjectSpecifier().parentTask.flagged, true] },
		{completed: false, blocked: false , _match: [ObjectSpecifier().parentTask.dueDate, {"<":dueDate}] }
	]});	
	flattenedTasks().forEach(function(task){
		if ( !task.context.hidden &&  (!task.deferDate()) || (today > task.deferDate()) ) {
			context = (task.context() !== null) ? task.context().name() : '';
			project = (task.container() !== null) ? task.container().name() : '';
			taskDue = false;
			if (task.dueDate() || task.parentTask.dueDate()){
				taskDue = true;
			};
			taskList.push({
				name: task.name(),
				id: task.id(),
				context: context,
				project: project,
				note: task.note(),
				due: taskDue,
				
			});
		}
	});
		
	retObj = {
		'tasks' : taskList,
		'count' : taskList.length
	};

	return JSON.stringify(retObj);
}                              � jscr  ��ޭ