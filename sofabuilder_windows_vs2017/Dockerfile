# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.7.2.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.7.2-windowsservercore-ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install Visual Studio Build Tools 2017
# To see component names, run Visual Studio Installer and play with configuration export.
# Use --passive instead of --quiet when testing (GUI will appear with progress bar).
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
ADD https://raw.githubusercontent.com/guparan/DockerSofaBuilder/master/sofabuilder_windows_vs2017/wait_process_to_end.bat C:\TEMP\wait_process_to_end.bat	
RUN C:\TEMP\vs_buildtools.exe --wait --quiet --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Workload.VCTools `
	--add microsoft.visualstudio.component.vc.cmake.project `
	--add microsoft.visualstudio.component.testtools.buildtools `
	--add microsoft.visualstudio.component.vc.atlmfc `
	--add microsoft.visualstudio.component.vc.cli.support `
	& C:\TEMP\wait_process_to_end.bat "vs_bootstrapper.exe" `
	& C:\TEMP\wait_process_to_end.bat "vs_BuildTools.exe" `
	& C:\TEMP\wait_process_to_end.bat "vs_installer.exe"
ENV VS150COMNTOOLS C:\BuildTools\Common7\Tools

# Start developer command prompt with any other commands specified.
# ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&

# Install Qt
ENV QT_VERSION_MAJOR 5
ENV QT_VERSION_MINOR 12
ENV QT_VERSION_PATCH 6
ENV QTDIR C:\Qt
ENV QTDIR64 C:\Qt
ADD https://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe C:\TEMP\qtinstaller.exe
ADD https://raw.githubusercontent.com/guparan/DockerSofaBuilder/master/sofabuilder_windows_vs2017/qtinstaller_controlscript_template.qs C:\TEMP\qtinstaller_controlscript_template.qs
RUN powershell -Command "(gc C:\TEMP\qtinstaller_controlscript_template.qs) -replace '_QTVERSION_', %QT_VERSION_MAJOR%%QT_VERSION_MINOR%%QT_VERSION_PATCH% | Out-File -encoding ASCII C:\TEMP\qtinstaller_controlscript.qs"
RUN C:\TEMP\qtinstaller.exe --script C:\TEMP\qtinstaller_controlscript.qs

# Install Boost
ENV BOOST_VERSION_MAJOR 1
ENV BOOST_VERSION_MINOR 69
ENV BOOST_VERSION_PATCH 0
ADD https://downloads.sourceforge.net/project/boost/boost-binaries/${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}/boost_${BOOST_VERSION_MAJOR}_${BOOST_VERSION_MINOR}_${BOOST_VERSION_PATCH}-msvc-14.1-64.exe boostinstaller.exe
ADD https://raw.githubusercontent.com/guparan/DockerSofaBuilder/master/sofabuilder_windows_vs2017/wait_process_to_end.bat C:\TEMP\wait_process_to_end.bat	
RUN boostinstaller.exe /NORESTART /VERYSILENT /DIR="C:\boost"
	& C:\TEMP\wait_process_to_end.bat "boostinstaller.exe"

# Install Chocolatey
RUN @powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command `
    "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" `
	&& SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install dependencies with Chocolatey
RUN choco install -y git
RUN choco install -y zip
RUN choco install -y unzip
RUN choco install -y curl
RUN choco install -y ninja
RUN choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'
# RUN choco install -y boost-msvc-14.1
RUN choco install -y python2 && refreshenv && python --version
RUN pip install --upgrade pip && pip --version
RUN pip install numpy scipy

# FROM build-env as qt-build-env
# LABEL Description="Environment for Building Qt"
# RUN choco install -y jom --version 1.1.2 && jom /version

# Download and extract Qt source archives
# WORKDIR C:/
# RUN md src
# WORKDIR src
# COPY build-qt.bat .
# ADD http://download.qt.io/official_releases/qt/5.12/5.12.5/submodules/qtbase-everywhere-src-5.12.5.zip qtbase.zip
# ADD http://download.qt.io/official_releases/qt/5.12/5.12.5/submodules/qtscript-everywhere-src-5.12.5.zip qtscript.zip
# ADD http://download.qt.io/official_releases/qt/5.12/5.12.5/submodules/qttools-everywhere-src-5.12.5.zip qttools.zip
# RUN unzip qtbase.zip
# RUN unzip qtscript.zip
# RUN unzip qttools.zip
# RUN rename qtbase-everywhere-src-5.12.5 qtbase
# RUN rename qtscript-everywhere-src-5.12.5 qtscript
# RUN rename qttools-everywhere-src-5.12.5 qttools
# RUN build-qt.bat x86
# RUN build-qt.bat x64


# FROM build-env as qbs-build-env
# WORKDIR C:/
# COPY --from=qt-build-env C:/Qt C:/Qt/

# Start developer command prompt with any other commands specified.
#ENTRYPOINT "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\Tools\VsDevCmd.bat" &&

ENV PYTHONIOENCODING UTF-8
RUN setx PATH "%PATH%;C:\Program Files (x86)\Windows Kits\8.1\bin\x64" `
  & setx PATH "%PATH%;C:\Program Files (x86)\Windows Kits\10\bin\x64" `
  & setx PATH "%PATH%;C:\Qt\%QT_VERSION_MAJOR%.%QT_VERSION_MINOR%.%QT_VERSION_PATCH%\msvc2017_64\bin" `
  & setx PATH "%PATH%;C:\Qt\Tools\QtCreator\bin" `
  & setx PATH "%PATH%;C:\boost" `
  & setx PATH "%PATH%;C:\boost\lib64-msvc-14.1" `
  & refreshenv

# Default to PowerShell if no other command specified.
# CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
CMD ["C:\Program Files\Git\bin\bash.exe"]