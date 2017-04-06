#!/usr/bin/perl
#
# This tool is under license GPL v3
# This tool is made in perl and HackerOrientado made this tool
# HackerOrientado ( Ciência Hacker )
#

#################### Modules
use strict;
use warnings;
use Time::localtime;
use Tkx;
use File::Copy;
use utf8;
########################

#################### Input/Output UTF-8
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
########################

#################### System information
my $OS = $^O;
########################

#################### Global variables
my ( $clear, $count, $numArquivos1, $numArquivos2, $window_help, $box_ip_Local_iDevice, $ip_Local_iDevice, $Janela_Principal, $label );
my ( $b_BackupPhotos, $b_Ajuda, $b_Fechar, $label_purple, $b1_Window_Help, $b2_Window_Help, $b3_Window_Help );
my @arquivos;
my @arquivosCheck;
my @infos_iDevice;
my @push_array_info;
########################

#################### System commands
my $version = "1.2.1";

if ( $OS eq "win32" ) {

	$clear = "cls";
	
	system $clear;
	system "title iDPT - v$version";

} elsif ( $OS eq "linux" ) {

	$clear = "clear";

	system $clear;

} else {

	warn "Ops.. Something wrong happened\n";
	warn "I can't check wich is your system\n";

}
########################

#################### Variables of date
my $dia = localtime->mday();
my $mes = localtime->mon() +1;
my $ano = localtime->year() + 1900;
my $pasta = "$dia-$mes-$ano";
#############

#################### Sub routine of help popup
sub mensagem_ajuda {

	Tkx::tk___messageBox (

		-parent		=> $Janela_Principal,
		-icon 		=> "info",
		-title 		=> "Help",
		-type 		=> "ok",
		-message	=> "Help menu for iDPT\n\n".
		"Click in the option what you want\n",
		
	);

	$window_help = $Janela_Principal -> new_toplevel;
	$window_help -> g_wm_title ( "iDPT Help" );
	$window_help -> m_configure ( -background => "#1fa679" );
#	$window_help -> g_wm_minsize ( 200, 250 );

	$b1_Window_Help = $window_help -> new_button (

		-background => "white",
		-text 		=> "How it works\?",
		-command 	=> sub {

			Tkx::tk___messageBox (

				-parent		=> $window_help,
				-icon		=> "info",
				-title 		=> "How it works\?",
				-type 		=> "ok",
				-message 	=> "\nThis tool was made in Perl and works with OpenSSH ".
				"to communicate with your iDevice.\n\nThis tool needs no cables to works.\n",

			);

		},

	);

	$b2_Window_Help = $window_help -> new_button (

		-background	=> "white",
		-text 		=> "What is OpenSSH\?",
		-command 	=> sub {

			Tkx::tk___messageBox (

				-parent		=> $window_help,
				-icon 		=> "info",
				-title 		=> "What is OpenSSH\?",
				-type 		=> "ok",
				-message 	=> "\nOpenSSH is a free open source utility like is the SSH ( from ".
				"SSH Communications Security ). \n\nOpenSSH was developed as a part of project OpenBSD.\n",

			);

		},

	);

	$b3_Window_Help = $window_help -> new_button (

		-background	=> "white",
		-text 		=> "Problem with iDPT\?",
		-command 	=> sub {

			Tkx::tk___messageBox (

				-parent		=> $window_help,
				-icon 		=> "info",
				-title 		=> "Problem with iDPT\?",
				-type 		=> "ok",
				-message 	=> "\nMake sure you have OpenSSH ( if you is using Windows ).\nI recommend the ".
				"OpenSSH from Mls-Software. Google it or check iDPT GitHub.\n\nYou MUST need have Jailbreak and OpenSSH installed ".
				"in your iDevice.",

			);

		},

	);

	$label_purple = $window_help -> new_ttk__label ( -text => "HackerOrientado black is the new purple" );
	$label_purple -> m_configure ( 

		-justify 	=> "center",
		-background => "#1fa679",
		-foreground => "purple",

	);

	$b1_Window_Help -> g_pack (

		-padx => 10,
		-pady => 10,

	);

	$b2_Window_Help -> g_pack (

		-padx => 10,
		-pady => 0,

	);

	$b3_Window_Help -> g_pack (

		-padx => 10,
		-pady => 10,

	);

	$label_purple -> g_pack (

		-padx => 10,
		-pady => 15,

	);

}
########################

#################### Sub routine of Backup Photos
sub ssh() {

	system $clear;

	if ( -e "Backup$pasta" ) {

		print "Folder is already created\!\n\n";

	} else {

		system "mkdir Backup$pasta";

	}

	print "Enter with your SSH root password\n\n";
	
	system "scp root\@$ip_Local_iDevice:/var/mobile/Media/DCIM/100APPLE/* .";
	
	opendir (DIR, ".");
	@arquivos = grep ( /\.JPG/|/\.PNG/|/\.MOV/|/\.mov/|/\.XMP/|/\.SLM/|/\.mp4/, readdir(DIR) );
	close ( DIR );
	
	$numArquivos1 = @arquivos;
		
	for ( $count = 0; $count < $numArquivos1; $count++ ) {
		
		move ( $arquivos[$count], "Backup$pasta" );

	}

	print "\n";

	opendir (DIR, "Backup$pasta");
	@arquivos = grep ( /\.JPG/|/\.PNG/|/\.MOV/|/\.mov/|/\.XMP/|/\.SLM/|/\.mp4/, readdir(DIR) );
	close  ( DIR );

	$numArquivos2 = @arquivos;

	if ( $numArquivos2 = $numArquivos1 ) {

		print "Backup was made\!\n\n";

	} else {

		print "Ops\! Something wrong happened.\n\n";

	}
	
}
########################


#################### Main window configure
$Janela_Principal = Tkx::widget -> new ( "." );
$Janela_Principal -> g_wm_title ( "iDPT - v$version" );
$Janela_Principal -> m_configure ( -background => "#1fa679" );
$Janela_Principal -> g_wm_minsize ( 300, 330  );
########################


#################### Label interface
$label = $Janela_Principal -> new_ttk__label ( -text => "
iDPT - iDevice Perl Tool - v$version

Made by HackerOrientado

Enter with your local IP of your iDevice
Click on the button for make your action
" );

$label -> m_configure ( -justify	=> "center" );
$label -> m_configure ( -background => "#1fa679" );

$box_ip_Local_iDevice = $Janela_Principal -> new_ttk__entry ( -textvariable => \$ip_Local_iDevice );
$box_ip_Local_iDevice -> m_configure ( -foreground 	=> "black" );
$box_ip_Local_iDevice -> m_configure ( -justify	=> "center" );
$box_ip_Local_iDevice -> insert (0, "Your iDevice local IP" );
########################

#################### Buttons 
$b_BackupPhotos = $Janela_Principal -> new_button (

	-background	=> "white",
	-text 		=> "Backup photos",
	-command 	=> sub {
	
		$b_BackupPhotos -> m_configure (

			-text 		=> "Connecting.....",
		
		);
		
		Tkx::after (
		
			500, sub {
			
				$b_BackupPhotos -> m_configure ( 

					-text 		=> "Conect ao SSH", 
					
				) 
			}
		);
		
		Tkx::after (
		
			500, sub {
			
				return ssh()
			
			}
		
		);
		
		
	},
);

$b_Ajuda = $Janela_Principal -> new_button (

	-background	=> "white",
	-text 		=> "Help",
	-command 	=> \&mensagem_ajuda,

);

$b_Fechar = $Janela_Principal -> new_button (

	-background	=> "white",
	-text 		=> "Close program",
    -command 	=> sub {
		
		$b_Fechar -> m_configure (
		
			-text => "Closing..",
        
		);

		Tkx::after ( 500, sub { $Janela_Principal -> g_destroy } );

	},
);
########################


#################### Pack buttons
$label -> g_pack (

	-padx => 0,
	-pady => 5,

);

$box_ip_Local_iDevice -> g_pack (

	-padx => 0,
	-pady => 0,

);

$b_BackupPhotos -> g_pack (

	-padx => 0,
    -pady => 40,

);

$b_Ajuda -> g_pack (

	-padx => 0,
	-pady => 0,

);

$b_Fechar -> g_pack (

	-padx => 10,
	-pady => 5,

);
########################

#################### Loop for main window
Tkx::MainLoop();
########################


#################### This space is reserved for futures updates
# Adicionar uma tela própria para ajuda usando o widget do Tkx e criar novos botões criando PopUP explicando cada menu da ajuda
# Organizar o code
