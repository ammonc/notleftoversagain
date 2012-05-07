// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

  function unit_changed() {
    var select = $('ingredient_unit_id');
    var index = select.selectedIndex;
    var value = select.options[select.selectedIndex].value;
    var text = select.options[select.selectedIndex].text;
    //alert(index + ' => ' + value + ' => ' + text);
    if (value == 0) {
      new_unit_name = prompt('Enter a new unit:', 'each');
      //alert('You said ' + new_unit_name + '. About to add that new category...');  
      if (new_unit_name != null) {
        new_unit_abbrev = prompt('Now enter an abbreviation for ' + new_unit_name+ ' (leave off the period at the end):', '');
        if (new_unit_abbrev != null)
	  new Ajax.Updater('ingredient_unit_id-container', '/recipe_box/add_unit', {onLoading:function(request){ Element.show('indicator'); }, onComplete:function(request){Element.hide('indicator'); }, parameters:'unit_name=' + encodeURIComponent(new_unit_name) + '&unit_abbrev=' + encodeURIComponent(new_unit_abbrev), evalScripts:true, asynchronous:true});
        else
	  alert('You clicked cancel on unit abbrev.');
      } else
        alert('You clicked cancel on unit name.');
    }
  }

  function ingredient_category_changed() {
    var select = $('ingredient_ingredient_category_id');
    var index = select.selectedIndex;
    var value = select.options[select.selectedIndex].value;
    var text = select.options[select.selectedIndex].text;
    //alert(index + ' => ' + value + ' => ' + text);
    if (value == 0) {
      new_ingredient_category_name = prompt('Enter a new ingredient category:', 'Meat');
      //alert('You said ' + new_ingredient_category_name + '. About to add that new category...');  
      if (new_ingredient_category_name != null)
        new Ajax.Updater('ingredient_ingredient_category_id-container', '/recipe_box/add_ingredient_category', {onLoading:function(request){ Element.show('indicator'); }, onComplete:function(request){Element.hide('indicator'); }, parameters:'ingredient_category_name=' + encodeURIComponent(new_ingredient_category_name), evalScripts:true, asynchronous:true});
    }
  }
