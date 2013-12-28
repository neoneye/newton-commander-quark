Pod::Spec.new do |s|
  s.name         = "newton-commander-quark"
  s.version      = "0.1.2"
  s.summary      = "Shared low-level code used across Newton Commander's submodules."
  s.description  = <<-DESC
      A quark is an elementary particle and a fundamental constituent of matter.
	  
	  Features
	  - Copying files
	  - Moving files
	  - Listing content of a folder
      DESC
  s.homepage     = "https://github.com/neoneye/newton-commander-quark"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Simon Strandgaard" => "simon@opcoders.com" }
  s.source       = { :git => "https://github.com/neoneye/newton-commander-quark.git", :tag => s.version.to_s }

  s.platform     = :osx, '10.9'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  # s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios', 'Classes/osx/*Test.*'
  s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
