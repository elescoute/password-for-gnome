project('password', ['c', 'vala'], 
          version: '1.0.2',
          license: 'GPL3+',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)

gnome = import('gnome')
i18n = import('i18n')

###############
# Directories #
###############

prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
icondir = join_paths(datadir, 'icons')
localedir = get_option('localedir')

###################
# End directories #
###################



#################
# Configuration #
#################

profile = get_option('profile')
conf = configuration_data()
name_suffix = ''
app_id = 'org.emilien.Password'
conf.set_quoted('APP_ID', app_id)
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PROFILE', profile)
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('LICENSE', meson.project_license())
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

#####################
# End configuration #
#####################
subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
