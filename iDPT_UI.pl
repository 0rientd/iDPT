#!/usr/bin/perl

use strict;
use warnings;
use Time::localtime;
use Tkx;
use File::Copy;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

system "cls";
system "title iDPT - v1.0";

# VARIAVEIS GLOBAIS
my ( $count, $numArquivos, $box_ip_Local_iDevice, $ip_Local_iDevice, $Janela_Principal, $label, $b_BackupPhotos, $b_Ajuda, $b_Fechar );
my @arquivos;
my @arquivosCheck;
my @infos_iDevice;
my @push_array_info;

# Data para a criação da pasta
my $dia = localtime->mday();
my $mes = localtime->mon() +1;
my $ano = localtime->year() + 1900;
my $pasta = "$dia-$mes-$ano";
#############

# sub rotinas
sub mensagem_ajuda {

	Tkx::tk___messageBox (
		
		-parent		=> $Janela_Principal,
		-icon 		=> "info",
		-title 		=> "Ajuda",
		-type 		=> "ok",
		-message	=> "Menu de ajuda para o iDPT\n\n" .
		"Para usar o programa, clique na opção desejada\n" .
		"e digite a senha 'root' do seu OpenSSH ( questões de seg. )\n\n",
		
	);
		
}

sub ssh() {

	system "mkdir backup$pasta";

	print "Digite a senha SSH do usuario root de seu iDevice\n\n";
	
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

# Janela Principal
$Janela_Principal = Tkx::widget -> new ( "." );
$Janela_Principal -> g_wm_title ( "iDPT - v1.0" );
$Janela_Principal -> g_wm_minsize ( 300, 200 );

#################### Interface
$label = $Janela_Principal -> new_ttk__label ( -text => "
               iDPT - iDevice Perl Tool - v1.0\n

          Entre com o IP Local de seu iDevice e
 clique no botão desejado para realizar sua ação
" );

$box_ip_Local_iDevice = $Janela_Principal -> new_ttk__entry ( -textvariable => \$ip_Local_iDevice );
$box_ip_Local_iDevice -> insert (0, "IP local do iDevice" );

#################### Botões 
$b_BackupPhotos = $Janela_Principal -> new_button (

	-text => "Conect ao SSH",
	-command => sub {
	
		$b_BackupPhotos -> m_configure (
		
			-text => "Conectando ..",
			
		);
		
		Tkx::after ( 
			500, sub { 
				$b_BackupPhotos -> m_configure ( 
			
					-text => "Conect ao SSH", 

				) 
			} 
		);
		
		return ssh();
		
	},

);

$b_Ajuda = $Janela_Principal -> new_button (

	-text => "Ajuda",
	-command => \&mensagem_ajuda,

);

$b_Fechar = $Janela_Principal -> new_button (

	-text => "Fechar programa",
    -command => sub {
		
		$b_Fechar -> m_configure (
		
			-text => "Fechando programa...",
        
		);

		Tkx::after ( 500, sub { $Janela_Principal -> g_destroy } );

	},
);
########################


#################### Pack do botões
$label -> g_pack (

	-padx => 0,
	-pady => 0,

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

	-padx => 0,
	-pady => 5,

);
########################

#Loop para manter a tela
Tkx::MainLoop();

###########
# Adicionar uma tela própria para ajuda usando o widget do Tkx e criar novos botões criando PopUP explicando cada menu da ajuda
