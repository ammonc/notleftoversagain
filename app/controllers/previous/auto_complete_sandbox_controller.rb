class AutoCompleteSandboxController < ApplicationController
  auto_complete_for :contact, :name
  
  def index
    redirect_to :action => 'autocompleted_sandbox'
  end

  def autocompleted_sandbox
    
  end
end
