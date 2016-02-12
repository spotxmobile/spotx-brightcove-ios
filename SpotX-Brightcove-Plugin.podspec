# Copyright (c) 2016 spotxchange. All rights reserved.
#
# Be sure to run `pod spec lint' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.version          = '0.1.0'
  s.name             = 'SpotX-Brightcove-Plugin'
  s.summary          = 'Brightcove plugin for SpotX'
  s.authors          = 'SpotX, Inc.'
  s.homepage         = 'http://www.spotxchange.com'
  s.source           = { :git => 'https://github.com/spotxmobile/spotx-brightcove-ios.git', branch: 'dev' }
  s.license          =  'MIT'
  s.platform         = :ios, '7.0'
  s.requires_arc     = true

  s.source_files  = 'spotx-brightcove-ios/*.{h,m}'
  s.public_header_files = [
    'spotx-brightcove-ios/BCOVSpotXComponent.h'
  ]


  s.dependency 'Brightcove-Player-SDK/dynamic', '~> 5.0'
  s.dependency 'SpotX-SDK', '~> 2.1'
  #s.dependency 'SpotX-SDK-src'
end
