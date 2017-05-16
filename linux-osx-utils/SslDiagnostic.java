import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;

public class SslDiagnostic {
	
	private static SSLSocketFactory getSslSocketFactory(String tlsVersion) throws Exception {
		
		SSLContext ctx;
		try {
			ctx = SSLContext.getInstance(tlsVersion);
		} catch (NoSuchAlgorithmException nsae) {
			throw new RuntimeException("Unable to create SSLContext of type " + tlsVersion, nsae);
		}

		try {
			ctx.init(null, null, null);
		} catch (KeyManagementException kme) {
			throw new RuntimeException("Unable to initialize SSLContext", kme);
		}

		return ctx.getSocketFactory();
	}
	
	public static void main(String[] args) throws Exception {
		System.setProperty("javax.net.debug", "ssl:handshake:session:sslctx:plaintext");
		
		testTls("TLSv1.0");
		testTls("TLSv1.1");
		testTls("TLSv1.2");
	}
	
	private static void testTls(String tlsVersion) throws Exception {
		try {
			System.out.println("\n--------------- start " + tlsVersion + " ------------------------");
			
			URL url = new URL("https://risk.test.kount.net");
			final HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
			connection.setSSLSocketFactory(getSslSocketFactory(tlsVersion));
			connection.setUseCaches(false);
			
			System.out.println("--------------- connect --------------------------");
			connection.connect();
			System.out.println("--------------- disconnect -----------------------");
			connection.disconnect();
			System.out.println("--------------- end " + tlsVersion + " --------------------------");
		} catch (Exception e) {
			String jVersion = System.getProperty("java.runtime.version");
			double jVersionDouble = Double.parseDouble(jVersion.substring(0, 3));
			System.out.println("Cannot proceed with " + tlsVersion + " connection; java version is: " + jVersion);
			if (jVersionDouble < 1.8) {
				e.printStackTrace(System.err);
			}
		}
	}
}
