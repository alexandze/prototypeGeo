# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

def production_pods
    pod 'RxSwift', '~> 5'
    pod 'RxCocoa', '~> 5'
    pod 'ReSwift'
    pod 'RealmSwift'
end

def test_pods
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
end

target 'AgroApp' do
    production_pods
end
