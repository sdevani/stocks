class TransactionScript
  def self.run(params={})
    self.new.run(params)
  end

  def failure(error, data={})
    data[:success?] = false
    data[:error] = error
    return OpenStruct.new(data)
  end

  def success(data={})
    data[:success?] = true
    return OpenStruct.new(data)
  end
end