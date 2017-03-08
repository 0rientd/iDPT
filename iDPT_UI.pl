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

#################### System commands
my $version = "1.1";
system "cls";
system "title iDPT - v$version";

#################### Global variables
my ( $count, $numArquivos, $box_ip_Local_iDevice, $ip_Local_iDevice, $Janela_Principal, $label, $b_BackupPhotos, $b_Ajuda, $b_Fechar );
my @arquivos;
my @arquivosCheck;
my @infos_iDevice;
my @push_array_info;
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
		-message	=> "Help menu for iDPT\n\n" .
		"Click in the option and enter your\n" .
		"OpenSSH root password\n\n",
		
	);
		
}
########################

#################### Sub routine of Backup Photos
sub ssh() {

	system "mkdir backup$pasta";

	print "Enter with your SSH root password\n\n";
	
	system "scp root\@$ip_Local_iDevice:/var/mobile/Media/DCIM/100APPLE/* .";
	
	opendir (DIR, ".");
	@arquivos = grep ( /\.JPG/|/\.PNG/|/\.MOV/|/\.mov/|/\.XMP/|/\.SLM/, readdir(DIR) );
	close ( DIR );
	
	$numArquivos = @arquivos;
		
	for ( $count = 0; $count < $numArquivos; $count++ ) {
		
		move ( $arquivos[$count], "backup$pasta" );

	}

	print "\n";

	opendir (DIR, "Backup$pasta");
	@arquivos = grep ( /\.JPG/|/\.PNG/|/\.MOV/|/\.XMP/|/\.SLM/, readdir(DIR) );
	close  ( DIR );
	
	print "Backup realizado com sucesso\!\n\n";
	
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

Made by HackerOrientado ( Ciência Hacker )

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