(function ($) {
    $(function() {
        window.menuTourSteps = [
            {
                'next .members-menu-item': I18n.t('js.onboarding.steps.members'),
                'showSkip': false,
                'nextButton': {text: I18n.t('js.onboarding.buttons.next')},
            },
            {
                'next .wiki-menu--main-item': I18n.t('js.onboarding.steps.wiki'),
                'showSkip': false,
                'nextButton': {text: I18n.t('js.onboarding.buttons.next')},
            },
            {
                'next .menu-item--help': I18n.t('js.onboarding.steps.help_menu'),
                'shape': 'circle',
                'showSkip': false,
                'nextButton': {text: I18n.t('js.onboarding.buttons.got_it')}
            }
        ];
    });
}(jQuery))
