builder.broken_packages(count: count) do |broken_package|
  broken_packages.each do |package|
    broken_package.package(package: package[:package], project: package[:project])
  end
end
