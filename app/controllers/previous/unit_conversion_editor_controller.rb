class UnitConversionEditorController < ApplicationController

  def index
    redirect_to :action => 'list'
  end

  def list
    @unit_conversions = UnitConversion.find(:all, :order => 'smaller_unit_id')
    @units = Unit.find_all
  end

  def update
    id = params[:id]
    @unit_conversion = UnitConversion.find(id)
    if @unit_conversion.update_attributes(params[:unit_conversion])  # performs save
      render_text 'Save successful'
    else
      render_text 'Save failed'
    end
  end

  def create
    @unit_conversion = UnitConversion.new(params[:unit_conversion])
    result = nil
    if @unit_conversion.save
      result = 'Unit conversion was successfully created.'
    else
      result = "Unit conversion FAILED to save!"
    end

    @units = Unit.find_all
    unit_options = @units.collect {|u| [ u.abbrev, u.id ] }
    render :partial => 'unit_conversion_form_part', :locals => {:unit_options => unit_options}
  end

  def delete
    id = params[:id]
    UnitConversion.delete(id)
    render_text ''
  end

end
