require 'json'

package = JSON.parse(File.read(File.join(__dir__, './package.json')))

fabric_enabled = ENV['RCT_NEW_ARCH_ENABLED'] == '1'

Pod::Spec.new do |s|
  s.name         = "RNBoundary"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = "https://github.com/skedlife/react-native-boundary#readme"

  s.source       = { :git => "https://github.com/skedlife/react-native-boundary.git", :tag => "#{s.version}" }
  s.source_files  = "ios/*.{h,m,mm}"
  s.requires_arc = true

  if fabric_enabled
    folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

    s.pod_target_xcconfig = {
      'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/boost" "$(PODS_ROOT)/boost-for-react-native" "$(PODS_ROOT)/RCT-Folly"',
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    }
    s.platforms       = { ios: '11.0', tvos: '11.0' }
    s.compiler_flags  = folly_compiler_flags + ' -DRCT_NEW_ARCH_ENABLED'

    install_modules_dependencies(s)
  else
    s.platforms = { :ios => "9.0" }

    s.dependency "React-Core"
  end
end
