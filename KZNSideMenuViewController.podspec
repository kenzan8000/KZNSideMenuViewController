Pod::Spec.new do |s|

  s.name         = "KZNSideMenuViewController"
  s.version      = "0.2"
  s.summary      = "."
  s.description  = <<-DESC
                   A longer description of KZNSideMenuViewController in Markdown format.

                   * KZNSideMenuViewController is tested on iOS 5.0+ and requires ARC.
                   DESC
  s.homepage     = "http://kenzan8000.org"
  s.license      = { :type => 'MIT' }
  s.author       = { "Kenzan Hase" => "kenzan8000@gmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/kenzan8000/KZNSideMenuViewController.git", :tag => "v0.2" }
  s.source_files = 'KZNSideMenuViewController/*.{h,m}'
  s.requires_arc = true
  # s.exclude_files = 'Classes/Exclude'
  # s.public_header_files = 'Classes/**/*.h'
end
