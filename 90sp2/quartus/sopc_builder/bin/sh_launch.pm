# sh_launch.pm - set up environment for launching from shell
# used originally by nios2 tools (hence the quirkily
# specific names for the JRE ha ha) but now 2005(5.1)
# available in sopc builder too.
sub BEGIN
{
    # de-dossify some of our favorite environment variables
	$ENV{QUARTUS_ROOTDIR} =~ s|\\|/|g;
	$ENV{SOPC_KIT_NIOS2} =~ s|\\|/|g;
	$ENV{SOPC_KIT_NIOS2} =~ s|/cygdrive/(.)/(.*)|$1:/$2|g;
	$ENV{SOPC_KIT_NIOS2} =~ s|/ecos-(.)/(.*)|$1:/$2|g;
	my $Q = $ENV{QUARTUS_ROOTDIR};
	$Q =~ s|(.):/(.*)|/cygdrive/$1/$2|;
	@INC = ("$Q/sopc_builder/bin", "$Q/sopc_builder/bin/perl_lib", @INC);
    # argument resemble a path? change it.
	for (my $argc=0; $argc < scalar(@ARGV); $argc++)
	{
		@ARGV[$argc] =~ s|^(.*)/cygdrive/(.)/(.*)|$1$2:/$3|;
		@ARGV[$argc] =~ s|^(.*)/ecos-(.)/(.*)|$1$2:/$3|;
	}
	my $PLATBIN="bin";
	if ($^O =~ /linux/i) { $PLATBIN="linux"; }
	elsif ($^O =~ /sun/i) { $PLATBIN="solaris"; }
	$nios2sh_BIN = "$ENV{SOPC_KIT_NIOS2}/bin";
	$nios2sh_JRE = "$ENV{QUARTUS_ROOTDIR}/$PLATBIN/jre/bin/java";
	$quartus_JRE = "$ENV{QUARTUS_ROOTDIR}/$PLATBIN/jre/bin/java";
	$sopc_builder_BIN = "$ENV{QUARTUS_ROOTDIR}/sopc_builder/bin";
}
1; # success
