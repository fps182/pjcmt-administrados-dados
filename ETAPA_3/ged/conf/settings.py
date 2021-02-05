from .base import *  # noqa

DEBUG = False
# debug variable in templates is available only if INTERNAL_IPS are set
# to a not empty list
INTERNAL_IPS = [
    '127.0.0.1',
]

ALLOWED_HOSTS = ['*']

INSTALLED_APPS.extend(
    ['mod_wsgi.server', ]
)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'dbpolicia',
        'USER': 'pjcmt',
        'PASSWORD': '6tBXh*Eb',
        'HOST': 'dbpolicia',
        'PORT': 5432,
    },
}

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file_worker': {
            'class': 'logging.FileHandler',
            'filename': 'worker.log',
        },
        'file_app': {
            'class': 'logging.FileHandler',
            'filename': 'app.log',
        },
    },
    'loggers': {
        'mglib': {
            'handlers': ['file_app'],
            'level': 'DEBUG'
        },
        'papermerge': {
            'handlers': ['file_app'],
            'level': 'DEBUG'
        },
        'celery': {
            'handlers': ['file_worker'],
            'level': 'INFO'
        },
    },
}