# Name our project
project('com.github.lainsce.paraula', ['vala', 'c'],
    version: '0.1.0'
)

# Import main lib files
gnome = import('gnome')
i18n = import('i18n')

# Set this for convenience
conf = configuration_data()

# Get the package data directory under Meson
pkgdatadir = join_paths([ get_option('prefix'),
                          get_option('datadir'),
                          'com.github.lainsce.paraula' ])

conf.set_quoted('PKGDATADIR', pkgdatadir)

# Other configs
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf
add_global_arguments('-DDATADIR="' + get_option('datadir') + '"', language: 'c')
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

# Arguments for C
c_args = [
  '-include', 'config.h',
  '-w'
]

cc = meson.get_compiler('c')

# Let's define our executable
executable(
    meson.project_name(),
    'src/Constants/Stylesheet.vala',
    'src/Core/Definition.vala',
    'src/Core/PearsonApiClient.vala',
    'src/Views/View.vala',
    'src/Views/WordListView.vala',
    'src/Views/SearchView.vala',
    'src/Views/NormalView.vala',
    'src/Views/DefinitionView.vala',
    'src/Widgets/WordListRow.vala',
    'src/Application.vala',
    'src/MainWindow.vala',
    c_args: c_args,
    dependencies: [
        dependency('granite'),
        dependency('gobject-2.0'),
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('gio-2.0'),
        dependency('gee-0.8')
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi',
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install : true
)

# Add in a post install script
meson.add_install_script('meson/post_install.py')

# Add subfolders for Meson to look
subdir('data')
subdir('po')