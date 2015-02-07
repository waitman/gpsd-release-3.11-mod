PREFIX=/usr/local
INSTALL=/usr/bin/install

all: gpsd

gpsd:
	cc -o ais_json.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC ais_json.c
	cc -o bits.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC bits.c
	cc -o daemon.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC daemon.c
	cc -o gpsutils.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC gpsutils.c
	cc -o gpsdclient.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC gpsdclient.c
	cc -o gps_maskdump.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC gps_maskdump.c
	cc -o hex.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC hex.c
	cc -o json.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC json.c
	cc -o libgps_core.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC libgps_core.c
	cc -o libgps_dbus.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC libgps_dbus.c
	cc -o libgps_json.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC libgps_json.c
	cc -o libgps_shm.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC libgps_shm.c
	cc -o libgps_sock.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC libgps_sock.c
	cc -o netlib.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC netlib.c
	cc -o rtcm2_json.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC rtcm2_json.c
	cc -o rtcm3_json.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC rtcm3_json.c
	cc -o shared_json.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC shared_json.c
	cc -o strl.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC strl.c
	cc -o getsid.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC getsid.c
	cc -o libgps.so.21.0.0 -pthread -shared -Wl,-Bsymbolic -Wl,-soname=libgps.so.21 -Wl,-rpath=//usr/local/lib ais_json.os bits.os daemon.os gpsutils.os gpsdclient.os gps_maskdump.os hex.os json.os libgps_core.os libgps_dbus.os libgps_json.os libgps_shm.os libgps_sock.os netlib.os rtcm2_json.os rtcm3_json.os shared_json.os strl.os getsid.os -L. -lm -lrt -lrt
	cc -o bsd_base64.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC bsd_base64.c
	cc -o crc24q.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC crc24q.c
	cc -o gpsd_json.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC gpsd_json.c
	cc -o geoid.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC geoid.c
	cc -o isgps.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC isgps.c
	cc -o libgpsd_core.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC libgpsd_core.c
	cc -o net_dgpsip.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC net_dgpsip.c
	cc -o net_gnss_dispatch.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC net_gnss_dispatch.c
	cc -o net_ntrip.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC net_ntrip.c
	cc -o ppsthread.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC ppsthread.c
	cc -o packet.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC packet.c
	cc -o pseudonmea.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC pseudonmea.c
	cc -o pseudoais.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC pseudoais.c
	cc -o serial.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC serial.c
	cc -o subframe.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC subframe.c
	cc -o timebase.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC timebase.c
	cc -o drivers.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC drivers.c
	cc -o driver_ais.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_ais.c
	cc -o driver_evermore.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_evermore.c
	cc -o driver_garmin.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_garmin.c
	cc -o driver_garmin_txt.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_garmin_txt.c
	cc -o driver_geostar.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_geostar.c
	cc -o driver_italk.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_italk.c
	cc -o driver_navcom.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_navcom.c
	cc -o driver_nmea0183.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_nmea0183.c
	cc -o driver_nmea2000.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_nmea2000.c
	cc -o driver_oncore.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_oncore.c
	cc -o driver_rtcm2.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_rtcm2.c
	cc -o driver_rtcm3.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_rtcm3.c
	cc -o driver_sirf.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_sirf.c
	cc -o driver_superstar2.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_superstar2.c
	cc -o driver_tsip.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_tsip.c
	cc -o driver_ubx.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_ubx.c
	cc -o driver_zodiac.os -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 -fPIC driver_zodiac.c
	cc -o libgpsd.so.22.0.0 -pthread -shared -Wl,-Bsymbolic -Wl,-soname=libgpsd.so.22 -Wl,-rpath=//usr/local/lib bsd_base64.os crc24q.os gpsd_json.os geoid.os isgps.os libgpsd_core.os net_dgpsip.os net_gnss_dispatch.os net_ntrip.os ppsthread.os packet.os pseudonmea.os pseudoais.os serial.os subframe.os timebase.os drivers.os driver_ais.os driver_evermore.os driver_garmin.os driver_garmin_txt.os driver_geostar.os driver_italk.os driver_navcom.os driver_nmea0183.os driver_nmea2000.os driver_oncore.os driver_rtcm2.os driver_rtcm3.os driver_sirf.os driver_superstar2.os driver_tsip.os driver_ubx.os driver_zodiac.os -L. -lm -lrt -lusb -lrt
	rm -f libgpsd.so; ln -s libgpsd.so.22.0.0 libgpsd.so
	rm -f libgpsd.so.22; ln -s libgpsd.so.22.0.0 libgpsd.so.22
	rm -f libgpsd.so.22.0; ln -s libgpsd.so.22.0.0 libgpsd.so.22.0
	rm -f libgps.so; ln -s libgps.so.21.0.0 libgps.so
	rm -f libgps.so.21; ln -s libgps.so.21.0.0 libgps.so.21
	rm -f libgps.so.21.0; ln -s libgps.so.21.0.0 libgps.so.21.0
	cc -o gpsd.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gpsd.c
	cc -o ntpshm.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 ntpshm.c
	cc -o shmexport.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 shmexport.c
	cc -o dbusexport.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 dbusexport.c
	cc -o gpsd -pthread -Wl,-rpath=//usr/local/lib gpsd.o ntpshm.o shmexport.o dbusexport.o -L. -lrt -lgpsd -lusb -lgps -lm
	cc -o gpsdecode.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gpsdecode.c
	cc -o gpsdecode -pthread -Wl,-rpath=//usr/local/lib gpsdecode.o -L. -lrt -lgpsd -lusb -lgps -lm
	cc -o gpsctl.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gpsctl.c
	cc -o gpsctl -pthread -Wl,-rpath=//usr/local/lib gpsctl.o -L. -lrt -lgpsd -lusb -lgps -lm
	cc -o gpsdctl.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gpsdctl.c
	cc -o gpsdctl -pthread -Wl,-rpath=//usr/local/lib gpsdctl.o -L. -lrt -lgps -lm
	cc -o gpspipe.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gpspipe.c
	cc -o gpspipe -pthread -Wl,-rpath=//usr/local/lib gpspipe.o -L. -lrt -lgps -lm
	cc -o gps2udp.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gps2udp.c
	cc -o gps2udp -pthread -Wl,-rpath=//usr/local/lib gps2udp.o -L. -lrt -lgps -lm
	cc -o gpxlogger.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gpxlogger.c
	cc -o gpxlogger -pthread -Wl,-rpath=//usr/local/lib gpxlogger.o -L. -lrt -lgps -lm
	cc -o lcdgps.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 lcdgps.c
	cc -o lcdgps -pthread -Wl,-rpath=//usr/local/lib lcdgps.o -L. -lrt -lgps -lm
	cc -o cgps.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 cgps.c
	cc -o cgps -pthread -Wl,-rpath=//usr/local/lib cgps.o -L. -lrt -lgps -lm -lncurses
	cc -o gpsmon.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 gpsmon.c
	cc -o monitor_italk.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_italk.c
	cc -o monitor_nmea.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_nmea.c
	cc -o monitor_oncore.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_oncore.c
	cc -o monitor_sirf.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_sirf.c
	cc -o monitor_superstar2.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_superstar2.c
	cc -o monitor_tnt.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_tnt.c
	cc -o monitor_ubx.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_ubx.c
	cc -o monitor_garmin.o -c -D_GNU_SOURCE -Wextra -Wall -Wno-uninitialized -Wno-missing-field-initializers -Wcast-align -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith -Wreturn-type -pthread -Wmissing-prototypes -Wmissing-declarations -O2 monitor_garmin.c
	cc -o gpsmon -pthread -Wl,-rpath=//usr/local/lib gpsmon.o monitor_italk.o monitor_nmea.o monitor_oncore.o monitor_sirf.o monitor_superstar2.o monitor_tnt.o monitor_ubx.o monitor_garmin.o -L. -lrt -lgpsd -lusb -lgps -lncurses -lm

clean:
	rm -f *.o
	rm -f libgps.so*
	rm -f libgpsd.so*
	rm -f gpsd
	rm -f gpsdecode
	rm -f gpsctl
	rm -f gpsdctl
	rm -f gpspipe
	rm -f gps2udp
	rm -f gpxlogger
	rm -f lcdgps
	rm -f cgps
	rm -f gpsmon

deinstall:
	rm -f $(PREFIX)/lib/libgps.so*
	rm -f $(PREFIX)/lib/libgpsd.so*
	rm -f $(PREFIX)/sbin/gpsd
	rm -f $(PREFIX)/bin/gpsdecode
	rm -f $(PREFIX)/sbin/gpsctl
	rm -f $(PREFIX)/sbin/gpsdctl
	rm -f $(PREFIX)/bin/gpspipe
	rm -f $(PREFIX)/bin/gps2udp
	rm -f $(PREFIX)/bin/gpxlogger
	rm -f $(PREFIX)/bin/lcdgps
	rm -f $(PREFIX)/bin/cgps
	rm -f $(PREFIX)/bin/gpsmon

install:
	$(INSTALL) -s -m 0755 -o root -g wheel libgps.so.21.0.0 $(PREFIX)/lib/
	$(INSTALL) -s -m 0755 -o root -g wheel libgpsd.so.22.0.0 $(PREFIX)/lib/
	$(INSTALL) -s -m 0755 -o root -g wheel gpsd $(PREFIX)/sbin/
	$(INSTALL) -s -m 0755 -o root -g wheel gpsdecode $(PREFIX)/bin/
	$(INSTALL) -s -m 0755 -o root -g wheel gpsctl $(PREFIX)/sbin/
	$(INSTALL) -s -m 0755 -o root -g wheel gpsdctl $(PREFIX)/sbin/
	$(INSTALL) -s -m 0755 -o root -g wheel gpspipe $(PREFIX)/bin/
	$(INSTALL) -s -m 0755 -o root -g wheel gps2udp $(PREFIX)/bin/
	$(INSTALL) -s -m 0755 -o root -g wheel gpxlogger $(PREFIX)/bin/
	$(INSTALL) -s -m 0755 -o root -g wheel lcdgps $(PREFIX)/bin/
	$(INSTALL) -s -m 0755 -o root -g wheel cgps $(PREFIX)/bin/
	$(INSTALL) -s -m 0755 -o root -g wheel gpsmon $(PREFIX)/bin/
	ln -s $(PREFIX)/lib/libgps.so.21.0.0 $(PREFIX)/lib/libgps.so.21.0
	ln -s $(PREFIX)/lib/libgps.so.21.0.0 $(PREFIX)/lib/libgps.so.21
	ln -s $(PREFIX)/lib/libgps.so.21.0.0 $(PREFIX)/lib/libgps.so
	ln -s $(PREFIX)/lib/libgpsd.so.22.0.0 $(PREFIX)/lib/libgpsd.so.22.0
	ln -s $(PREFIX)/lib/libgpsd.so.22.0.0 $(PREFIX)/lib/libgpsd.so.22
	ln -s $(PREFIX)/lib/libgpsd.so.22.0.0 $(PREFIX)/lib/libgpsd.so



