CREATE DATABASE BDSpotPer
ON
	PRIMARY
	(
		NAME = 'BDSpotPer',                         
		FILENAME = 'C:\FBD-FINAL\BDSpotPer.mdf',   
		SIZE = 5120KB,                              
		FILEGROWTH = 1024KB                         
	),
	FILEGROUP BDSpotPer_fg01
	(
		NAME = 'BDSpotPer_001',                     
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_001.ndf',
		SIZE = 1024KB,                              
		FILEGROWTH = 30%                            
	),
	(
		NAME = 'BDSpotPer_002',                     
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_002.ndf',
		SIZE = 1024KB,                              
		MAXSIZE = 3072KB,                           
		FILEGROWTH = 15%                            
	),
	FILEGROUP BDSpotPer_fg02
	(
		NAME = 'BDSpotPer_003',                    
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_003.ndf',
		SIZE = 2048KB,                              
		MAXSIZE = 5120KB,                          
		FILEGROWTH = 30%                            
	)
	LOG ON 
	(
		NAME = 'BDSpotPer_log',                     
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_log.ldf',
		SIZE = 1024KB,                              
		FILEGROWTH = 10%                            
	);
