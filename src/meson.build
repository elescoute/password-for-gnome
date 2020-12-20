password_sources = [
  'config.vapi',
  'main.vala',
  'window.vala',
  'mdpCalcul.vala',
  'mdpAleatoire.vala',
]

password_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('libhandy-1', version: '>= 1.0.0'),
]

gnome = import('gnome')

password_sources += gnome.compile_resources('password-resources',
  'password.gresource.xml',
  c_name: 'password'
)

password_vala_args = [
	'--target-glib=2.50',
	'--vapidir', meson.current_source_dir(),
]

password_c_args = [
	'-include', 'config.h',
]

executable('password', password_sources,
  include_directories: config_h_dir,
  vala_args: password_vala_args,  dependencies: password_deps,
  c_args: password_c_args,
  install: true,
)
