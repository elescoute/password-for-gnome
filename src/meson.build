password_sources = [
  'main.vala',
  'window.vala',
  'mdpCalcul.vala',
  'mdpAleatoire.vala',
]

password_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
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

executable('password', password_sources,
  vala_args: password_vala_args,  dependencies: password_deps,
  install: true,
)
