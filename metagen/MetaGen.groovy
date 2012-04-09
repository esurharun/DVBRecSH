import java.io.*;
import org.red5.io.flv.impl.*;
import org.red5.io.flv.meta.*;
import org.red5.io.*;



void generate(File dir,File rootDir) {
 def appFlvPattern = ~/([a-zA-Z0-9]+)(-)(\d+)(_)(\d+)(_)(\d+)(-)(\d+)(_)(\d+)(_)(\d+)(-)(\d+)(_)(\d+)(_)(\d+)(\.)(flv)/
 File[] files = dir.listFiles();
 println(" Dir: "+dir.getAbsolutePath());
 for (File file : files) {

	def matcher = (file.getName() =~ appFlvPattern)
	if (matcher.matches()) {
	//	println(" File: "+file.getAbsolutePath());
		def targetDir = rootDir.getAbsolutePath()+File.separator+matcher[0][1]+File.separator+matcher[0][3]+File.separator+matcher[0][5]+File.separator+matcher[0][7]+File.separator
		def targetMeta = new File(targetDir+file.getName()+".meta")
		def targetFlv  = targetDir+file.getName()
                if (!(targetMeta.exists()))
                {

			try {			
			def strMkdir = ["mkdir", "-p" ,targetDir]
		//	println strMkdir
			def mkdirProc = strMkdir.execute()
			mkdirProc.consumeProcessOutput()
			mkdirProc.waitFor()
			print("[] Moving file..");
			def strMvProc = ["mv", file.getAbsolutePath(), targetFlv]
		//	println(strMvProc)
			def mvProc = strMvProc.execute()
			mvProc.consumeProcessOutput()
			mvProc.waitFor()
			print("DONE\n")
			println("[] Processing "+targetFlv+" ");
			def tFlvFile = new File(targetFlv)
			FLVReader reader = new FLVReader(tFlvFile,true);
                        FileKeyFrameMetaCache cache = new FileKeyFrameMetaCache();
                        cache.saveKeyFrameMeta(tFlvFile, reader.analyzeKeyFrames());
		//	System.exit(0)
			} catch (Exception e) {
				e.printStackTrace();
			}
                }
        } else if (file.isDirectory()) {
                generate(file,rootDir);
        }
 }
}

//File dir = new File(args[0]);
println("args: "+args)
generate(new File(args[0]),new File(args[0]));
