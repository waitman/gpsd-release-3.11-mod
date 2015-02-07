/*
 * This file is Copyright (c) 2010 by the GPSD project
 * BSD terms apply: see the file COPYING in the distribution root for details.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#ifndef S_SPLINT_S
#include <unistd.h>
#endif /* S_SPLINT_S */

#include "gpsd.h"
#include "gps_json.h"

static int verbose = 0;
static bool scaled = true;
static bool json = true;
static bool split24 = false;
static unsigned int ntypes = 0;
static unsigned int typelist[32];

/**************************************************************************
 *
 * Generic machinery
 *
 **************************************************************************/

ssize_t gpsd_write(struct gps_device_t *session,
		   const char *buf,
		   const size_t len)
/* pass low-level data to devices straight through */
{
    return gpsd_serial_write(session, buf, len);
}

void gpsd_report(const int debuglevel, const int errlevel,
		 const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    gpsd_labeled_report(debuglevel, errlevel, "gpsdecode:", fmt, ap);
    va_end(ap);
			
}

#ifdef AIVDM_ENABLE
static void aivdm_csv_dump(struct ais_t *ais, char *buf, size_t buflen)
{
    char scratchbuf[MAX_PACKET_LENGTH*2+1];
    bool imo = false;

    (void)snprintf(buf, buflen, "%u|%u|%09u|", ais->type, ais->repeat,
		   ais->mmsi);
    /*@ -formatcode @*/
    switch (ais->type) {
    case 1:			/* Position Report */
    case 2:
    case 3:
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%d|%u|%u|%d|%d|%u|%u|%u|0x%x|%u|0x%x",
		       ais->type1.status,
		       ais->type1.turn,
		       ais->type1.speed,
		       (uint) ais->type1.accuracy,
		       ais->type1.lon,
		       ais->type1.lat,
		       ais->type1.course,
		       ais->type1.heading,
		       ais->type1.second,
		       ais->type1.maneuver,
		       (uint) ais->type1.raim, ais->type1.radio);
	break;
    case 4:			/* Base Station Report */
    case 11:			/* UTC/Date Response */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%04u-%02u-%02uT%02u:%02u:%02uZ|%u|%d|%d|%u|%u|0x%x",
		       ais->type4.year,
		       ais->type4.month,
		       ais->type4.day,
		       ais->type4.hour,
		       ais->type4.minute,
		       ais->type4.second,
		       (uint) ais->type4.accuracy,
		       ais->type4.lon,
		       ais->type4.lat,
		       ais->type4.epfd,
		       (uint) ais->type4.raim, ais->type4.radio);
	break;
    case 5:			/* Ship static and voyage related data */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%s|%s|%u|%u|%u|%u|%u|%u|%02u-%02uT%02u:%02uZ|%u|%s|%u",
		       ais->type5.imo,
		       ais->type5.ais_version,
		       ais->type5.callsign,
		       ais->type5.shipname,
		       ais->type5.shiptype,
		       ais->type5.to_bow,
		       ais->type5.to_stern,
		       ais->type5.to_port,
		       ais->type5.to_starboard,
		       ais->type5.epfd,
		       ais->type5.month,
		       ais->type5.day,
		       ais->type5.hour,
		       ais->type5.minute,
		       ais->type5.draught,
		       ais->type5.destination, ais->type5.dte);
	break;
    case 6:			/* Binary Message */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%u|%u",
		       ais->type6.seqno,
		       ais->type6.dest_mmsi,
		       (uint) ais->type6.retransmit,
		       ais->type6.dac,
		       ais->type6.fid);
	switch(ais->type6.dac) {
	case 235:			/* UK */
	case 250:			/* Rep. Of Ireland */
	    switch(ais->type6.fid) {
	    case 10:		/* GLA - AtoN monitoring */
		(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			       "|%u|%u|%u|%u|%u|%u|%u|%u",
			       ais->type6.dac235fid10.ana_int,
			       ais->type6.dac235fid10.ana_ext1,
			       ais->type6.dac235fid10.ana_ext2,
			       ais->type6.dac235fid10.racon,
			       ais->type6.dac235fid10.light,
			       (uint)ais->type6.dac235fid10.alarm,
			       ais->type6.dac235fid10.stat_ext,
			       (uint)ais->type6.dac235fid10.off_pos);
		imo = true;
		break;
	    }
	    break;
	}
	if (!imo)
	    (void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			   "|%zd:%s",
			   ais->type6.bitcount,
			   gpsd_hexdump(scratchbuf, sizeof(scratchbuf),
					ais->type6.bitdata,
					(ais->type6.bitcount + 7) / 8));
	break;
    case 7:			/* Binary Acknowledge */
    case 13:			/* Safety Related Acknowledge */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%u",
		       ais->type7.mmsi1,
		       ais->type7.mmsi2, ais->type7.mmsi3, ais->type7.mmsi4);
	break;
    case 8:			/* Binary Broadcast Message */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u",
		       ais->type8.dac,
		       ais->type8.fid);
	switch(ais->type8.dac) {
	case 1:			/* International */
	    switch(ais->type8.fid) {
	    case 11:		/* IMO236 - Met/Hydro message */
		(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			       "|%d|%d|%02uT%02u:%02uZ|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%d|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u",
			       ais->type8.dac1fid11.lon,
			       ais->type8.dac1fid11.lat,
			       ais->type8.dac1fid11.day,
			       ais->type8.dac1fid11.hour,
			       ais->type8.dac1fid11.minute,
			       ais->type8.dac1fid11.wspeed,
			       ais->type8.dac1fid11.wgust,
			       ais->type8.dac1fid11.wdir,
			       ais->type8.dac1fid11.wgustdir,
			       ais->type8.dac1fid11.airtemp,
			       ais->type8.dac1fid11.humidity,
			       ais->type8.dac1fid11.dewpoint,
			       ais->type8.dac1fid11.pressure,
			       ais->type8.dac1fid11.pressuretend,
			       ais->type8.dac1fid11.visibility,
			       ais->type8.dac1fid11.waterlevel,
			       ais->type8.dac1fid11.leveltrend,
			       ais->type8.dac1fid11.cspeed,
			       ais->type8.dac1fid11.cdir,
			       ais->type8.dac1fid11.cspeed2,
			       ais->type8.dac1fid11.cdir2,
			       ais->type8.dac1fid11.cdepth2,
			       ais->type8.dac1fid11.cspeed3,
			       ais->type8.dac1fid11.cdir3,
			       ais->type8.dac1fid11.cdepth3,
			       ais->type8.dac1fid11.waveheight,
			       ais->type8.dac1fid11.waveperiod,
			       ais->type8.dac1fid11.wavedir,
			       ais->type8.dac1fid11.swellheight,
			       ais->type8.dac1fid11.swellperiod,
			       ais->type8.dac1fid11.swelldir,
			       ais->type8.dac1fid11.seastate,
			       ais->type8.dac1fid11.watertemp,
			       ais->type8.dac1fid11.preciptype,
			       ais->type8.dac1fid11.salinity,
			       ais->type8.dac1fid11.ice);
		imo = true;
		break;
	    case 31:		/* IMO289 - Met/Hydro message */
		(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			       "|%d|%d|%02uT%02u:%02uZ|%u|%u|%u|%u|%d|%u|%d|%u|%u|%u|%d|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%d|%u|%u|%u",
			       ais->type8.dac1fid31.lon,
			       ais->type8.dac1fid31.lat,
			       ais->type8.dac1fid31.day,
			       ais->type8.dac1fid31.hour,
			       ais->type8.dac1fid31.minute,
			       ais->type8.dac1fid31.wspeed,
			       ais->type8.dac1fid31.wgust,
			       ais->type8.dac1fid31.wdir,
			       ais->type8.dac1fid31.wgustdir,
			       ais->type8.dac1fid31.airtemp,
			       ais->type8.dac1fid31.humidity,
			       ais->type8.dac1fid31.dewpoint,
			       ais->type8.dac1fid31.pressure,
			       ais->type8.dac1fid31.pressuretend,
			       ais->type8.dac1fid31.visibility,
			       ais->type8.dac1fid31.waterlevel,
			       ais->type8.dac1fid31.leveltrend,
			       ais->type8.dac1fid31.cspeed,
			       ais->type8.dac1fid31.cdir,
			       ais->type8.dac1fid31.cspeed2,
			       ais->type8.dac1fid31.cdir2,
			       ais->type8.dac1fid31.cdepth2,
			       ais->type8.dac1fid31.cspeed3,
			       ais->type8.dac1fid31.cdir3,
			       ais->type8.dac1fid31.cdepth3,
			       ais->type8.dac1fid31.waveheight,
			       ais->type8.dac1fid31.waveperiod,
			       ais->type8.dac1fid31.wavedir,
			       ais->type8.dac1fid31.swellheight,
			       ais->type8.dac1fid31.swellperiod,
			       ais->type8.dac1fid31.swelldir,
			       ais->type8.dac1fid31.seastate,
			       ais->type8.dac1fid31.watertemp,
			       ais->type8.dac1fid31.preciptype,
			       ais->type8.dac1fid31.salinity,
			       ais->type8.dac1fid31.ice);
		imo = true;
		break;
	    }
	    break;
	}
	if (!imo)
	    (void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			   "|%zd:%s",
			   ais->type8.bitcount,
			   gpsd_hexdump(scratchbuf, sizeof(scratchbuf),
					ais->type8.bitdata,
					(ais->type8.bitcount + 7) / 8));
	break;
    case 9:
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%d|%d|%u|%u|0x%x|%u|%u|0x%x",
		       ais->type9.alt,
		       ais->type9.speed,
		       (uint) ais->type9.accuracy,
		       ais->type9.lon,
		       ais->type9.lat,
		       ais->type9.course,
		       ais->type9.second,
		       ais->type9.regional,
		       ais->type9.dte,
		       (uint) ais->type9.raim, ais->type9.radio);
	break;
    case 10:			/* UTC/Date Inquiry */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u", ais->type10.dest_mmsi);
	break;
    case 12:			/* Safety Related Message */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%s",
		       ais->type12.seqno,
		       ais->type12.dest_mmsi,
		       (uint) ais->type12.retransmit, ais->type12.text);
	break;
    case 14:			/* Safety Related Broadcast Message */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%s", ais->type14.text);
	break;
    case 15:
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%u|%u|%u|%u|%u",
		       ais->type15.mmsi1,
		       ais->type15.type1_1,
		       ais->type15.offset1_1,
		       ais->type15.type1_2,
		       ais->type15.offset1_2,
		       ais->type15.mmsi2,
		       ais->type15.type2_1, ais->type15.offset2_1);
	break;
    case 16:
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%u|%u|%u",
		       ais->type16.mmsi1,
		       ais->type16.offset1,
		       ais->type16.increment1,
		       ais->type16.mmsi2,
		       ais->type16.offset2, ais->type16.increment2);
	break;
    case 17:
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%d|%d|%zd:%s",
		       ais->type17.lon,
		       ais->type17.lat,
		       ais->type17.bitcount,
		       gpsd_hexdump(scratchbuf, sizeof(scratchbuf),
				    ais->type17.bitdata,
				    (ais->type17.bitcount + 7) / 8));
	break;
    case 18:
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%d|%d|%u|%u|%u|0x%x|%u|%u|%u|%u|%u|%u|0x%x",
		       ais->type18.reserved,
		       ais->type18.speed,
		       (uint) ais->type18.accuracy,
		       ais->type18.lon,
		       ais->type18.lat,
		       ais->type18.course,
		       ais->type18.heading,
		       ais->type18.second,
		       ais->type18.regional,
		       (uint) ais->type18.cs,
		       (uint) ais->type18.display,
		       (uint) ais->type18.dsc,
		       (uint) ais->type18.band,
		       (uint) ais->type18.msg22,
		       (uint) ais->type18.raim, ais->type18.radio);
	break;
    case 19:
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%d|%d|%u|%u|%u|0x%x|%s|%u|%u|%u|%u|%u|%u|%u|%u|%u",
		       ais->type19.reserved,
		       ais->type19.speed,
		       (uint) ais->type19.accuracy,
		       ais->type19.lon,
		       ais->type19.lat,
		       ais->type19.course,
		       ais->type19.heading,
		       ais->type19.second,
		       ais->type19.regional,
		       ais->type19.shipname,
		       ais->type19.shiptype,
		       ais->type19.to_bow,
		       ais->type19.to_stern,
		       ais->type19.to_port,
		       ais->type19.to_starboard,
		       ais->type19.epfd,
		       (uint) ais->type19.raim,
		       ais->type19.dte, (uint) ais->type19.assigned);
	break;
    case 20:			/* Data Link Management Message */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u",
		       ais->type20.offset1,
		       ais->type20.number1,
		       ais->type20.timeout1,
		       ais->type20.increment1,
		       ais->type20.offset2,
		       ais->type20.number2,
		       ais->type20.timeout2,
		       ais->type20.increment2,
		       ais->type20.offset3,
		       ais->type20.number3,
		       ais->type20.timeout3,
		       ais->type20.increment3,
		       ais->type20.offset4,
		       ais->type20.number4,
		       ais->type20.timeout4, ais->type20.increment4);
	break;
    case 21:			/* Aid to Navigation */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%s|%u|%d|%d|%u|%u|%u|%u|%u|%u|%u|0x%x|%u|%u",
		       ais->type21.aid_type,
		       ais->type21.name,
		       (uint) ais->type21.accuracy,
		       ais->type21.lon,
		       ais->type21.lat,
		       ais->type21.to_bow,
		       ais->type21.to_stern,
		       ais->type21.to_port,
		       ais->type21.to_starboard,
		       ais->type21.epfd,
		       ais->type21.second,
		       ais->type21.regional,
		       (uint) ais->type21.off_position,
		       (uint) ais->type21.raim,
		       (uint) ais->type21.virtual_aid);
	break;
    case 22:			/* Channel Management */
	if (!ais->type22.addressed)
	    (void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			   "%u|%u|%u|%u|%d|%d|%d|%d|%u|%u|%u|%u",
			   ais->type22.channel_a,
			   ais->type22.channel_b,
			   ais->type22.txrx,
			   (uint) ais->type22.power,
			   ais->type22.area.ne_lon,
			   ais->type22.area.ne_lat,
			   ais->type22.area.sw_lon,
			   ais->type22.area.sw_lat,
			   (uint) ais->type22.addressed,
			   (uint) ais->type22.band_a,
			   (uint) ais->type22.band_b, ais->type22.zonesize);
	else
	    (void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			   "%u|%u|%u|%u|%u|%u|%u|%u|%u|%u",
			   ais->type22.channel_a,
			   ais->type22.channel_b,
			   ais->type22.txrx,
			   (uint) ais->type22.power,
			   ais->type22.mmsi.dest1,
			   ais->type22.mmsi.dest2,
			   (uint) ais->type22.addressed,
			   (uint) ais->type22.band_a,
			   (uint) ais->type22.band_b, ais->type22.zonesize);
	break;
    case 23:			/* Group Management Command */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%d|%d|%d|%d|%u|%u|%u|%u|%u",
		       ais->type23.ne_lon,
		       ais->type23.ne_lat,
		       ais->type23.sw_lon,
		       ais->type23.sw_lat,
		       ais->type23.stationtype,
		       ais->type23.shiptype,
		       ais->type23.txrx,
		       ais->type23.interval, ais->type23.quiet);
	break;
    case 24:			/* Class B CS Static Data Report */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%s|", ais->type24.shipname);
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|", ais->type24.shiptype);
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%s|", ais->type24.vendorid);
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|", ais->type24.model);
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|", ais->type24.serial);
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%s|", ais->type24.callsign);
	if (AIS_AUXILIARY_MMSI(ais->mmsi)) {
	    (void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			   "%u", ais->type24.mothership_mmsi);
	} else {
	    (void)snprintf(buf + strlen(buf), buflen - strlen(buf),
			   "%u|%u|%u|%u",
			   ais->type24.dim.to_bow,
			   ais->type24.dim.to_stern,
			   ais->type24.dim.to_port,
			   ais->type24.dim.to_starboard);
	}
	break;
    case 25:			/* Binary Message, Single Slot */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%u|%zd:%s",
		       (uint) ais->type25.addressed,
		       (uint) ais->type25.structured,
		       ais->type25.dest_mmsi,
		       ais->type25.app_id,
		       ais->type25.bitcount,
		       gpsd_hexdump(scratchbuf, sizeof(scratchbuf),
				    ais->type25.bitdata,
				    (ais->type25.bitcount + 7) / 8));
	break;
    case 26:			/* Binary Message, Multiple Slot */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%u|%u|%zd:%s:%u",
		       (uint) ais->type26.addressed,
		       (uint) ais->type26.structured,
		       ais->type26.dest_mmsi,
		       ais->type26.app_id,
		       ais->type26.bitcount,
		       gpsd_hexdump(scratchbuf, sizeof(scratchbuf),
				    ais->type26.bitdata,
				    (ais->type26.bitcount + 7) / 8),
		       ais->type26.radio);
	break;
    case 27:			/* Long Range AIS Broadcast message */
	(void)snprintf(buf + strlen(buf), buflen - strlen(buf),
		       "%u|%u|%d|%d|%u|%u|%u|%u",
		       ais->type27.status,
		       (uint)ais->type27.accuracy,
		       ais->type27.lon,
		       ais->type27.lat,
		       ais->type27.speed,
		       ais->type27.course,
		       (uint)ais->type27.raim,
		       (uint)ais->type27.gnss);
	break;
    default:
	(void)snprintf(buf + strlen(buf),
		       buflen - strlen(buf),
		       "unknown AIVDM message content.");
	break;
    }
    /*@ +formatcode @*/
    (void)strlcat(buf, "\r\n", buflen);
}
#endif

static bool filter(gps_mask_t changed, struct gps_device_t *session)
/* say whether a given message should be visible */
{
    if (ntypes == 0)
	return true;
    else {
	unsigned int i, t;

	if ((changed & AIS_SET)!=0)
	    t = session->gpsdata.ais.type;
	else if ((changed & RTCM2_SET)!=0)
	    t = session->gpsdata.rtcm2.type;
	else if ((changed & RTCM3_SET)!=0)
	    t = session->gpsdata.rtcm3.type;
	else
	    return true;
	for (i = 0; i < ntypes; i++)
	    if (t == typelist[i])
		return true;
    }
    return false;
}

/*@ -compdestroy -compdef -usedef -uniondef @*/
static void decode(FILE *fpin, FILE*fpout)
/* sensor data on fpin to dump format on fpout */
{
    struct gps_device_t session;
    struct gps_context_t context;
    struct policy_t policy;
    char buf[GPS_JSON_RESPONSE_MAX * 4];

    //This looks like a good idea, but it breaks regression tests
    //(void)strlcpy(session.gpsdata.dev.path, "stdin", sizeof(session.gpsdata.dev.path));
    memset(&policy, '\0', sizeof(policy));
    policy.json = json;
    policy.scaled = scaled;

    gps_context_init(&context);
    gpsd_time_init(&context, time(NULL));
    context.readonly = true;
    gpsd_init(&session, &context, NULL);
    gpsd_clear(&session);
    session.gpsdata.gps_fd = fileno(fpin);
    session.gpsdata.dev.baudrate = 38400;     /* hack to enable subframes */
    (void)strlcpy(session.gpsdata.dev.path,
		  "stdin",
		  sizeof(session.gpsdata.dev.path));

    for (;;)
    {
	gps_mask_t changed = gpsd_poll(&session);

	if (changed == ERROR_SET || changed == NODATA_IS)
	    break;
	if (session.packet.type == COMMENT_PACKET)
	    gpsd_set_century(&session);
	if (verbose >= 1 && TEXTUAL_PACKET_TYPE(session.packet.type))
	    (void)fputs((char *)session.packet.outbuffer, fpout);
	if ((changed & (REPORT_IS|SUBFRAME_SET|AIS_SET|RTCM2_SET|RTCM3_SET|PASSTHROUGH_IS)) == 0)
	    continue;
	if (!filter(changed, &session))
	    continue;
	else if (json) {
	    if ((changed & PASSTHROUGH_IS) != 0) {
		(void)fputs((char *)session.packet.outbuffer, fpout);
		(void)fputs("\n", fpout);
	    }
#ifdef SOCKET_EXPORT_ENABLE
	    else {
		if ((changed & AIS_SET)!=0) {
		    if (session.gpsdata.ais.type == 24 && session.gpsdata.ais.type24.part != both && !split24)
			continue;
		}
		json_data_report(changed,
				 &session, &policy,
				 buf, sizeof(buf));
		(void)fputs(buf, fpout);
	    }
#endif /* SOCKET_EXPORT_ENABLE */
#ifdef AIVDM_ENABLE
	} else if (session.packet.type == AIVDM_PACKET) {
	    if ((changed & AIS_SET)!=0) {
		if (session.gpsdata.ais.type == 24 && session.gpsdata.ais.type24.part != both && !split24)
		    continue;
		aivdm_csv_dump(&session.gpsdata.ais, buf, sizeof(buf));
		(void)fputs(buf, fpout);
	    }
#endif /* AIVDM_ENABLE */
	}
    }
}

#ifdef SOCKET_EXPORT_ENABLE
static void encode(FILE *fpin, FILE *fpout)
/* JSON format on fpin to JSON on fpout - idempotency test */
{
    char inbuf[BUFSIZ];
    struct policy_t policy;
    struct gps_device_t session;
    int lineno = 0;

    memset(&policy, '\0', sizeof(policy));
    memset(&session, '\0', sizeof(session));
    (void)strlcpy(session.gpsdata.dev.path,
		  "stdin",
		  sizeof(session.gpsdata.dev.path));
    policy.json = true;
    /* Parsing is always made in unscaled mode,
     * this policy applies to the dumping */
    policy.scaled = scaled;

    while (fgets(inbuf, (int)sizeof(inbuf), fpin) != NULL) {
	int status;

	++lineno;
	if (inbuf[0] == '#')
	    continue;
	status = libgps_json_unpack(inbuf, &session.gpsdata, NULL);
	if (status != 0) {
	    (void)fprintf(stderr,
			  "gpsdecode: dying with status %d (%s) on line %d\n",
			  status, json_error_string(status), lineno);
	    exit(EXIT_FAILURE);
	}
	json_data_report(session.gpsdata.set,
			 &session, &policy,
			 inbuf, sizeof(inbuf));
	(void)fputs(inbuf, fpout);
    }
}
/*@ +compdestroy +compdef +usedef @*/
#endif /* SOCKET_EXPORT_ENABLE */

int main(int argc, char **argv)
{
    int c;
    enum
    { doencode, dodecode } mode = dodecode;

    while ((c = getopt(argc, argv, "cdejpst:uvVD:")) != EOF) {
	switch (c) {
	case 'c':
	    json = false;
	    break;

	case 'd':
	    mode = dodecode;
	    break;

	case 'e':
	    mode = doencode;
	    break;

	case 'j':
	    json = true;
	    break;

	case 's':
	    split24 = true;
	    break;

	case 't':
	    /*@-nullpass@*/
	    typelist[ntypes++] = (unsigned int)atoi(strtok(optarg, ","));
	    for(;;) {
		char *next = strtok(NULL, ",");
		if (next == NULL)
		    break;
		typelist[ntypes++] = (unsigned int)atoi(next);
	    }
	    /*@+nullpass@*/
	    break;

	case 'u':
	    scaled = false;
	    break;

	case 'v':
	    verbose = 1;
	    break;

	case 'D':
	    verbose = atoi(optarg);
#if defined(CLIENTDEBUG_ENABLE) && defined(SOCKET_EXPORT_ENABLE)
	    json_enable_debug(verbose - 2, stderr);
#endif
	    break;

	case 'V':
	    (void)fprintf(stderr, "gpsdecode revision " VERSION "\n");
	    exit(EXIT_SUCCESS);

	case '?':
	default:
	    (void)fputs("gpsdecode [-v]\n", stderr);
	    exit(EXIT_FAILURE);
	}
    }
    //argc -= optind;
    //argv += optind;

    if (mode == doencode) {
#ifdef SOCKET_EXPORT_ENABLE
	encode(stdin, stdout);
#else
	(void)fprintf(stderr, "gpsdecode: encoding support isn't compiled.\n");
	exit(EXIT_FAILURE);
#endif /* SOCKET_EXPORT_ENABLE */
    } else
	decode(stdin, stdout);
    exit(EXIT_SUCCESS);
}

/* gpsdecode.c ends here */
