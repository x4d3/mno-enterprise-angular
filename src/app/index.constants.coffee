angular.module 'mnoEnterpriseAngular'
  .constant('URI', {
    login: '/mnoe/auth/users/sign_in',
    lounge: '/mnoe/auth/users/confirmation/lounge',
    dashboard: '/dashboard/',
    logout: '/mnoe/auth/users/sign_out'
  })
  .constant('LOCALSTORAGE', {
    appInstancesKey: 'appInstances'
  })
  .constant('LOCALES', {
    'locales': [
      { id: 'en', name: 'English', flag: '' },
      { id: 'id', name: 'Indonesian', flag: '' },
      { id: 'zh', name: 'Chinese (Singapore)', flag: '' }
    ],
    'preferredLocale': 'en',
    'fallbackLanguage': 'en'
  })
