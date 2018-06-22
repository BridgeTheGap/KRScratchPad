Pod::Spec.new do |s|

  s.name         = "KRScratchPad"
  s.version      = "1.0.1.4"
  s.summary      = "A scratch pad"
  s.description  = <<-DESC
The ScratchPad view allows users to easily draw/erase natural-looking strokes on a view.
                   DESC

  s.homepage = "https://github.com/BridgeTheGap/KRScratchPad"
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = { "Woomin Park" => "wmpark@knowre.com" }

  s.ios.deployment_target = "8.0"

  s.source = { :git => "https://github.com/BridgeTheGap/KRScratchPad.git", :tag => "#{s.version}" }

  s.source_files  = "KRScratchPad/*.{h,m}", "KRScratchPad/Classes/**/*"

end
