module QuestionnairesHelper
  
  def questionnaire_tab_items
    items = []
    items << ['Design', url_for(@questionnaire)]
    items << ['Settings', '']
    items << ['Collect data', '']
    items << ['Analyze', '']
    items << ['Export', '']
  end
  
  def arrange_contents_link
    arrange_text = icon(:sort, "Sort contents")
    arrange_text += content_tag("span","Sort")
    done_text = icon(:save)
    done_text += content_tag("span","Done")
    link_to_function "#{arrange_text}",
      toggle_contents + "if(this.down('span').innerHTML == 'Done'){
        this.innerHTML = '#{arrange_text}';
      } else {
        this.innerHTML = '#{done_text}';
      }"
  end
  
  def toggle_contents
    "$$('.content').each(
    	function(el){
    	  
    	  if(el.hasClassName('drag')){
				  el.removeClassName('drag')
				} else {
				  el.addClassName('drag')
				}
    	  
    		el.childElements().each(
    			function(innerEl){
    				if(!innerEl.hasClassName('text')){
    					innerEl.toggle()
    				}
    			}
    		)
    	}
    );"
  end
  
  def sort_contents_script
    "Sortable.create('contents', {onUpdate:function(){
    	new Ajax.Request('#{sort_questionnaire_contents_path(@questionnaire)}', {
    		asynchronous:true, 
    		evalScripts:true, 
    		method:'put', 
    		parameters:Sortable.serialize('contents')
    	})
    }});"
  end
  
end
