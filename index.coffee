# Set the refresh frequency (milliseconds).
refreshFrequency: 10000

style: """
  bottom: 50px
  right: 30px
  color: #fff
  font-family: Helvetica Neue
  font-size: 14px
  font-weight: 300
  width: 500px

  .tasks
	  margin: 0
	  padding: 0
  
  .task
      list-style: none
	  
  .task
	  margin: 0px
	  padding: 5px 25px 10px 20px
	  white-space: nowrap
	  overflow: hidden
	  text-align:right
	  text-overflow: ellipsis
	  position: relative
	  opacity: 0.85

  .task-note, .task-project, .task-context
	  position: relative
	  overflow: hidden
	  text-overflow: ellipsis
	  padding: 2px 0 0 0
	  font-size: 12px
	  color: rgba(128,128,128,1)

  .task-project, .task-context
  	  color: rgba(212,125,125, 1)

  .task::after
	  content: ""
	  position: absolute
	  width: 10px
	  height: 10px
	  background: rgba(0,0,0,0.2) 
	  -webkit-border-radius: 20px
	  border-style: solid
	  right: 0px
	  top: 7px

  .flagged::after
	  border-color: rgba(218,125,62,1)

  .due::after
	  border-color: rgba(211,167,0,1)

    .of-empty
    	width: auto
    	color: #fff
    	text-align: center
    	margin-top: 0
			
  a, a:link, a:visited
	  color: #fff
	  text-decoration: none
"""

render: (_) -> """
	<div id='todos'></div>
"""

command: "osascript './omnifocusflags.widget/of-flaggedTasks.scpt'"

update: (output, domEl) ->
	if output
		@ofObj = JSON.parse(output)
		@_render();
		$(domEl).find('#todos').html(@taskList)
	
_render: () ->
	@count = @ofObj.count;
	@taskList = '<ul class="list">'
	if @ofObj.tasks.length
		@ofObj.tasks.forEach (task) =>
			if task.due
				@taskList +=  '<li class="task due">'
			else
				@taskList +=  '<li class="task flagged">'

			@taskList +=  '<a href="omnifocus:///task/' + task.id + '">' + task.name + '</a>' +
						'<div>' + @_project(task) + @_context(task) + '</div>' +
				   	'</li>'
		@taskList += '</ul>'
	else
		@taskList = '<h4 class="of-empty">No Flagged Tasks</h4>'

_project: (task) =>
	return if (task.project and task.project != 'OmniFocus') then '<span class="task-project">' + task.project + '</span>' else ''

_context: (task) =>
	return if task.context then '<span class="task-context"> @ ' + task.context + '</span>' else ''