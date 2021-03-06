cask 'blender' do
  version '2.79a'
  sha256 'f0bfa07da853c4239d1b8c8f42bfedb164883cb7e67c9fe2006d8999be8516d5'

  url "https://download.blender.org/release/Blender#{version[0,4]}/blender-#{version}-macOS-10.6.zip"
  name 'Blender'
  homepage 'https://www.blender.org/'

  # Renamed for consistency: app name is different in the Finder and in a shell.
  app "blender-#{version}-macOS-10.6/blender.app", target: 'Blender.app'
  app "blender-#{version}-macOS-10.6/blenderplayer.app", target: 'Blenderplayer.app'
  # shim script (https://github.com/caskroom/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/blender.wrapper.sh"
  binary shimscript, target: 'blender'

  preflight do
    # make __pycache__ directories writable, otherwise uninstall fails
    FileUtils.chmod 'u+w', Dir.glob("#{staged_path}/*.app/**/__pycache__")

    IO.write shimscript, <<~EOS
      #!/bin/bash
      '#{appdir}/Blender.app/Contents/MacOS/blender' "$@"
    EOS
  end
end
