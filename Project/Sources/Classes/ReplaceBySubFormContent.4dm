
Class constructor
	This:C1470.label:="Replace by subform content"
	
Function onInvoke($editor : Object)->$result : Object
	
	var $currentSelection : Object
	$currentSelection:=This:C1470.currentSelection($editor)
	Case of 
		: ($currentSelection=Null:C1517)
			ALERT:C41("you must select a subform to delete and replace by its object")
		: ($currentSelection.type#"subform")
			ALERT:C41("you must select a subform to delete and replace by its object")
		Else 
			$folder:=Folder:C1567(fk database folder:K87:14; *).folder("Project/Sources/Forms/"+String:C10($currentSelection.detailForm))
			Case of 
				: (Not:C34($folder.exists))
					ALERT:C41("cannot find subform "+String:C10($currentSelection.detailForm))
				: (Not:C34($folder.file("form.4DForm").exists))
					ALERT:C41("cannot find  form.4DForm file for subform "+String:C10($currentSelection.detailForm))
				Else 
					
					$subFormData:=JSON Parse:C1218($folder.file("form.4DForm").getText())
					
					$objects:=$subFormData.pages[1].objects  // xxx support multiple page? maybe ask page number to user if support one page
					For each ($objectName; $objects)
						$object:=$objects[$objectName]
						OB REMOVE:C1226($object; "$4dId")  // to be able to add
						// offset subform pos
						$object.left:=$object.left+$currentSelection.left
						$object.top:=$object.top+$currentSelection.top
						
						If ($editor.editor.currentPage.objects[$objectName]#Null:C1517)
							$objectName:=$objectName+Generate UUID:C1066  // CLEAN just some random (better is to browser and find next in sequence)
						End if 
						$editor.editor.currentPage.objects[$objectName]:=$object
					End for each 
					
					// remove subform from here
					OB REMOVE:C1226($editor.editor.currentPage.objects; $editor.editor.currentSelection[0])
					
					$result:=New object:C1471("currentPage"; $editor.editor.currentPage)
					
			End case 
			
	End case 
	
Function currentSelection($editor)->$selection : Object
	If ($editor.editor.currentSelection#Null:C1517)
		If ($editor.editor.currentSelection.length#0)
			$selection:=$editor.editor.currentPage.objects[$editor.editor.currentSelection[0]]
		End if 
	End if 