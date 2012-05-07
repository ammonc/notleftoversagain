class DragNDropSandboxController < ApplicationController
  def index
    redirect_to :action => 'drag_n_drop_weekly_menu_planner_sandbox'
  end
  
  def drag_n_drop_weekly_menu_planner_sandbox
  end

  def schedule_meal_day_and_week
    logger.debug "Start of action: schedule_meal_day_and_week"
    logger.debug params.inspect
    
    #render_text params.inspect

    @weekly_menu_id = params[:weekly_menu_id]
    @daily_menu_id = params[:daily_menu_id] 
    @day_of_week = params[:day_of_week] 
    @meal_number = params[:meal_number] 
    @single_meal_menu_id = params[:single_meal_menu_id].split("_").last.to_i 
    render_partial 'schedule_meal_day_and_week'

    # give me the weekly_menu_id (created before weekly_menu was rendered (whether new weekly menu or filled weekly_menu))
    # from there, I can get the 7 daily_menu_ids (single_day_menu_ids?) (which need to be newly created (and built to be associated) for each weekly_menu)
    #  ?? TODO should all 6 meals be created here and initialized to nothing, or should they just be created on demand as things are added in that slot.  If they're created all at once, the on demand actions would be updates not loads
    # more importantly, though, I need the daily_menu_id where the day_of_week matches up, from which I can assign the single_meal_menu_id passed along with the correct ordering...
  end
  
  def unschedule_meal_day_and_week
    # Just need the meal_of_day_id (or the daily_menu_id and the meal_number) and possibly the weekly_menu_id 
    logger.debug "Start of action: unschedule_meal_day_and_week"
    logger.debug params.inspect
    
    @weekly_menu_id = params[:weekly_menu_id]
    @daily_menu_id = params[:daily_menu_id] 
    @meal_number = params[:meal_number] 
    
    # actually do the unscheduling
    
    render_text "Drop meal here!<br />&nbsp;"
  end
  
  # I decided **not** to support moving around complete days.  They can drag around menus from scheduled_meals instead
  
  
  # The question I have here is whether I can just put all the draggables/droppables definitions in statically or whether the ajax call has to append a script tag to allow the drag and drop functionality
  # I think that the id has to exist before the Draggable script is executed, but only the class has to be checked on a dragged item for a droppable callback to happen I think - we'll see


=begin
  def heidi
    logger.debug params.inspect
  
    txt_filename = params[:txt_filename]
    if txt_filename =~ /^filename\d.txt$/
      result = "Contents of #{txt_filename}: blah blah blah..."
    else
      result = "Filename #{txt_filename} not found."
    end
    render_text '<textarea cols="70" rows="20" id="txt_file_contents_textarea">' + result + '</textarea>'
  end
=end

end
