class StationInfo < Struct.new(:station, :passenger, :transition)

  def to_hash
    hash = {}
    members.each do |member|
      hash[member] = send(member)
    end
    hash
  end

end
