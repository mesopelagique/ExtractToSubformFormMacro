
Class constructor
	This:C1470.label:="Extract to subform"
	
Function onInvoke($editor : Object)->$result : Object
	
	var $currentSelections : Object
	$currentSelections:=This:C1470.currentSelections($editor)
	
	If (OB Keys:C1719($currentSelections).length#0)
		
		$subform:=New object:C1471("type"; "subform"; \
			"class"; ""; \
			"width"; 400; \
			"height"; 300; \
			"top"; 0; \
			"left"; 0)
		
		$coordinates:=This:C1470.enclosingRec($currentSelections)
		$subform.left:=$coordinates.left
		$subform.top:=$coordinates.top
		$subform.width:=$coordinates.right-$coordinates.left
		$subform.height:=$coordinates.bottom-$coordinates.top
		
		$i:=0
		While ($editor.editor.currentPage.objects["Subform"+String:C10($i)]#Null:C1517)
			$i:=$i+1
		End while 
		$editor.editor.currentPage.objects["Subform"+String:C10($i)]:=$subform
		
		$subform.detailForm:=Request:C163("form name?")
		If (Length:C16($subform.detailForm)>0)
			If (This:C1470.createForm($subform.detailForm; $currentSelections; $coordinates))
				
				// remove from current form
				For each ($name; $currentSelections)
					OB REMOVE:C1226($editor.editor.currentPage.objects; $name)
				End for each 
				
				
				$result:=New object:C1471("currentPage"; $editor.editor.currentPage)
				
			End if 
		End if 
		
		
	Else 
		ALERT:C41("Select elements to move it to a new subform")
	End if 
	
Function createForm($name : Text; $objects : Object; $coord : Object)->$ok : Boolean
	$ok:=False:C215
	$folder:=Folder:C1567(fk database folder:K87:14; *).folder("Project/Sources/Forms/"+$name)
	If ($folder.exists)
		ALERT:C41("alert already exists")
	Else 
		
		var $content : Object
		$content:=JSON Parse:C1218("{\"$4d\":{\"version\":\"1\",\"kind\":\"form\"},\"windowSizingX\":\"variable\",\"windowSizingY\":\"variable\",\"windowMinWidth\":0,\"windowMinHeight\":0,\"windowMaxWidth\":32767,\"windowMaxHeight\":32767,\"rightMargin\":20,\"bottomMargin\":20,\"events\":[\"onLoad\",\"onPageChange\",\"onVa"+"lidate\",\"onClick\",\"onDoubleClick\",\"onOutsideCall\",\"onBeginDragOver\",\"onDragOver\",\"onDrop\",\"onAfterKeystroke\",\"onMenuSelect\",\"onPluginArea\",\"onAfterEdit\",\"onTimer\",\"onBoundVariableChange\"],\"windowTitle\":\"window title\",\"destination\":\"detailScreen\",\"page"+"s\":[{\"objects\":{}},{\"objects\":{}}],\"geometryStamp\":5,\"editor\":{\"activeView\":\"View 1\",\"defaultView\":\"View 1\",\"views\":{\"View 1\":{}}}}")
		
		$content.pages[1].objects:=OB Copy:C1225($objects)
		For each ($objectName; $content.pages[1].objects)
			$object:=$content.pages[1].objects[$objectName]
			$object.left:=$object.left-$coord.left
			$object.top:=$object.top-$coord.top
		End for each 
		
		$folder.file("Form.4DForm").setText(JSON Stringify:C1217($content; *))
		$ok:=True:C214
	End if 
	
	
	
Function enclosingRec($objects : Object)->$coordinates : Object
	var $o; $element : Object
	For each ($name; $objects)
		
		$element:=$objects[$name]
		
		$o:=New object:C1471(\
			"left"; $element.left; \
			"top"; $element.top; \
			"right"; $element.left+$element.width; \
			"bottom"; $element.top+$element.height)
		
		If ($coordinates=Null:C1517)
			
			$coordinates:=$o
			
		Else 
			
			$coordinates.left:=Choose:C955($o.left<$coordinates.left; $o.left; $coordinates.left)
			$coordinates.top:=Choose:C955($o.top<$coordinates.top; $o.top; $coordinates.top)
			$coordinates.right:=Choose:C955($o.right>$coordinates.right; $o.right; $coordinates.right)
			$coordinates.bottom:=Choose:C955($o.bottom>$coordinates.bottom; $o.bottom; $coordinates.bottom)
			
		End if 
	End for each 
	
Function currentSelections($editor)->$selections : Object
	$selections:=New object:C1471
	If ($editor.editor.currentSelection#Null:C1517)
		For each ($name; $editor.editor.currentSelection)
			If ($editor.editor.currentPage.objects[$name]#Null:C1517)
				$selections[$name]:=$editor.editor.currentPage.objects[$name]
			End if 
		End for each 
	End if 