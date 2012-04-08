






import org.red5.io.flv.impl.*;
import org.red5.io.flv.meta.*;
import org.red5.io.*;

void generate(File dir) {
 File[] files = dir.listFiles();
 println(" Dir: "+dir.getAbsolutePath());
 for (File file : files) {

        if (file.getName().toLowerCase().endsWith(".flv")) {
                if (!(new File(file.getAbsolutePath()+".meta").exists()))
                {
                        println("[] Processing "+file.getName()+" ");
                        FLVReader reader = new FLVReader(file,true);
                        FileKeyFrameMetaCache cache = new FileKeyFrameMetaCache();
                        cache.saveKeyFrameMeta(file, reader.analyzeKeyFrames());
                }
        } else if (file.isDirectory()) {
                generate(file);
        }
 }
}

File dir = new File(args[0]);
generate(dir);
