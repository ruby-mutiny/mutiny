class Results  
  def for(line, change)
    table[[line, change]]
  end
  
  def record(mutant, result)
    table[[mutant.line, mutant.change]] = result
  end
  
  def length
    table.length
  end
  
  def kill_count
    table.values.select { |r| r == :killed }.size
  end
  
  def score
    kill_count.to_f / length.to_f
  end

  def to_s
    "\nkilled #{kill_count}; total #{length}; score #{score}"
  end

private
  def table
    @table ||= {}
  end
end