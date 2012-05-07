class SortableElementsSandboxController < ApplicationController

  def index
    redirect_to :action => 'sortable_elements'
  end

  def sortable_elements
    
  end

  
  def order
    @order = params[:list]
    render :partial => 'list'
  end

end
