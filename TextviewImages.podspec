Pod::Spec.new do |spec|
  spec.name             = 'TextviewImages'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'MIT' }
  spec.homepage         = 'https://github.com/ibhupi/TextviewImages'
  spec.authors          = {'Bhupendra Singh' => 'ibhupi@gmail.com'}
  spec.summary          = 'Textview Images For inserting images in text view'
  spec.source           = {:git => 'git@github.com:ibhupi/TextviewImages.git', :tag => '1.0.0'}
  spec.source_files     = 'TextviewImagesClass/*.{h,m}'
  spec.requires_arc     = true
end