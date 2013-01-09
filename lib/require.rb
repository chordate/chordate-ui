def require_all(*all)
  all.to_a.flatten.each do |lib|
    require lib
  end
end
