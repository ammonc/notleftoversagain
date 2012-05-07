=begin
class SameUnitException < Exception
end

class UnitConversionNotDefinedException < Exception
end
=end

class UnitConversion < ActiveRecord::Base
  def smaller_unit
    Unit.find(smaller_unit_id)
  end
  
  def larger_unit
    Unit.find(larger_unit_id)
  end
  
  # get smaller 1 -> larger (scale_factor (< 1) )
  def self.from_smaller_to_larger(given_smaller_unit_id, desired_larger_unit_id)
    raise 'SameUnitException' if given_smaller_unit_id == desired_larger_unit_id   # I suppose I could just return 1.0 since the loop would never execute...
    #raise SameUnitException if given_smaller_unit_id == desired_larger_unit_id   # I suppose I could just return 1.0 since the loop would never execute...
    
    current_smaller_unit_id = given_smaller_unit_id
    scale_factor = 1.0
    while (current_smaller_unit_id != desired_larger_unit_id)  # always at least one iteration
      #uc = find_by_sql("SELECT * FROM unit_conversions WHERE smaller_unit_id = #{current_smaller_unit_id} ORDER BY smaller_unit_amount DESC")  # get the most direct path if there is more than one
      uc = find_by_sql("SELECT * FROM unit_conversions WHERE smaller_unit_id = #{current_smaller_unit_id} ORDER BY smaller_unit_amount ASC LIMIT 1")  # get the shortest path if there is more than one, since if we take the larger path we might miss desired_larger_unit_id
      # we should impose the condition that there must be one and only one way of transitioning to a larger_unit.  Could that ever be unrealistic/problematic?  Seems like it could be, so I guess we just have to do it this way.  
      # The problem is that if there is more than one way to get from one unit to another and we happen to take one path instead of another, there may not be a path to the destination...  Maybe a graph-based algorithm is best, then
      # One possible enhancement is to store the transitive closure of the table (which makes deletes tougher since then you have to remove all transitive relationships that no longer hold...)
      raise 'UnitConversionNotDefinedException' if uc.empty?
      #raise UnitConversionNotDefinedException if uc.empty?
      scale_factor /= uc.first.smaller_unit_amount
      current_smaller_unit_id = uc.first.larger_unit_id
    end
    return scale_factor
  end
  
  
  # get 1 larger_unit  -> scale_factor (> 1) smaller_unit
  def self.from_larger_to_smaller(given_larger_unit_id, desired_smaller_unit_id)
    raise 'SameUnitException' if desired_smaller_unit_id == given_larger_unit_id  # I suppose I could just return 1.0 since the loop would never execute...
    #raise SameUnitException if desired_smaller_unit_id == given_larger_unit_id  # I suppose I could just return 1.0 since the loop would never execute...
    
    current_larger_unit_id = given_larger_unit_id
    scale_factor = 1
    while (current_smaller_unit_id != desired_larger_unit_id)  # always at least one iteration
      #uc = find_by_sql("SELECT * FROM unit_conversions WHERE smaller_unit_id = #{current_smaller_unit_id} ORDER BY smaller_unit_amount DESC")  # get the most direct path if there is more than one
      uc = find_by_sql("SELECT * FROM unit_conversions WHERE larger_unit_id = #{current_larger_unit_id} ORDER BY smaller_unit_amount ASC LIMIT 1")  # get the shortest path if there is more than one, since if we take the larger path we might miss desired_larger_unit_id
      # we should impose the condition that there must be one and only one way of transitioning to a larger_unit.  Could that ever be unrealistic/problematic?  Seems like it could be, so I guess we just have to do it this way.  
      # The problem is that if there is more than one way to get from one unit to another and we happen to take one path instead of another, there may not be a path to the destination...  Maybe a graph-based algorithm is best, then
      # One possible enhancement is to store the transitive closure of the table (which makes deletes tougher since then you have to remove all transitive relationships that no longer hold...)
      raise 'UnitConversionNotDefinedException' if uc.empty?
      raise UnitConversionNotDefinedException if uc.empty?
      scale_factor *= uc.first.smaller_unit_amount
      current_larger_unit_id = uc.first.smaller_unit_id
    end
    return scale_factor.to_f
  end
end
