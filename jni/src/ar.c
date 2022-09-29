/* Project: WTFOS Automatic recording package
 * Author: LouDFPV
 * Filename: ar.c
 * Created: 2022-09-21
 * Last modification: 2022-09-29
 * Version: v1
 */
#include <stdio.h>    // standard input output library
#include <stdlib.h>   // standards library
#include <stdbool.h>  // standard boolean types and values library
#include <unistd.h>   // miscellaneous symbolic constants and types library
#include <dlfcn.h>    // dynamic linking library
#include "ar.h"       // automatic recording library


uint32_t retrieve_timer(void *this)  // retrieve the timer function from the library
{
	if (libtp1801_timer == 0 && libtp1801_gui_dji)  // if timer is not initialized and the library is opened
	{
		libtp1801_timer = dlsym(libtp1801_gui_dji, "_ZN19GlassRacingChnlMenu7timeOutEv");  // retrieve address for the timer function
		if (libtp1801_timer == 0)  // if timer is still 0
		{
			LOGE("dlsym() error retrieving address for _ZN19GlassRacingChnlMenu7timeOutEv: %s \n", dlerror());  // throw an error
			return 0;  // and return 0
		}
		else
		{
			LOGD("libtp1801_timer address 0x%x retrieved\n", libtp1801_timer);  // log the address
			return libtp1801_timer(this);  // return the timer
		}
	}
	else
	{
		LOGD("libtp1801_timer address 0x%x\n", libtp1801_timer);  // log the address
		return libtp1801_timer(this);  // return the timer
	}
}


uint32_t retrieve_settings()  // retrieve the settings function from the library
{
	if (libtp1801_settings == 0 && libtp1801_gui_dji)  // if settings is not initialized and the library is opened
	{
		libtp1801_settings = dlsym(libtp1801_gui_dji, "_ZN17GlassUserSettings11getInstanceEv");  // retrieve address for the settings function
		if (libtp1801_settings == 0)  // if settings is still 0
		{
			LOGE("dlsym() error retrieving address for _ZN17GlassUserSettings11getInstanceEv: %s \n", dlerror());  // throw an error
			return 0;  // and return 0
		}
		else
		{
			LOGD("libtp1801_settings address 0x%x retrieved\n", libtp1801_settings);  // log the address
			return libtp1801_settings();  // return the settings
		}
	}
	else
	{
		LOGD("libtp1801_settings address 0x%x\n", libtp1801_settings);  // log the address
		return libtp1801_settings();  // return the settings
	}
}


void init()
{
	LOGD("Init libraries");
	if (libtp1801_gui_dji == 0)  // if the library is not yet opened
	{
		libtp1801_gui_dji = dlopen("/system/lib/libtp1801_gui.so", 1);  // open the gui library
		LOGD("libtp1801_gui.so opened");
	}
	LOGD("libtp1801_gui.so address 0x%x", libtp1801_gui_dji);

	if (ui_config == 0)  // if the ui config is not retrieved
	{
		ui_config = (__gs_gui_config *)*(uint32_t *)((int)retrieve_settings() + 0xe4);  // retrieve the config
		LOGD("ui_config initialized, 0x%x", ui_config);
	}
	LOGD("ui_config address 0x%x", ui_config);

	if (hardware_info == 0)  // if hardware info address is not retrieved
	{
		hardware_info = (uint32_t *)*(uint32_t *)((int) ui_config + 0x4c);  // retrieve the address for it from the config
		LOGD("hardware_info initialized, 0x%x", hardware_info);
	}
	LOGD("hardware_info address 0x%x", hardware_info);

	if (gs_modem_get_link_state_wrap == 0)  // if the current linkstate address is unknown
	{
    	gs_modem_get_link_state_wrap = (void *)*(uint32_t *)((int) ui_config + 0x228);  // retrieve the address for it  it from the config
		LOGD("gs_modem_get_link_state_wrap initialized, 0x%x", gs_modem_get_link_state_wrap);
  	}
	LOGD("gs_modem_get_link_state_wrap address 0x%x", gs_modem_get_link_state_wrap);

	if (gs_lv_transcode_get_state == 0)  // if the current transcode address is unknown
	{
		gs_lv_transcode_get_state = (void *)*(uint32_t *)((int) ui_config + 0x988);  // retrieve the address for it from the config
		LOGD("gs_lv_transcode_get_state initialized, 0x%x", gs_lv_transcode_get_state);
	}
	LOGD("gs_lv_transcode_get_state address 0x%x", gs_lv_transcode_get_state);

}


void update_connection_status()
{
	connection_status = GS_LINK_STAT_UKNOWN;  // set default connection_status to unknown
	gs_link_stat_t *connection_stat = &connection_status;  //
	gs_modem_get_link_state_wrap(hardware_info, connection_stat);  // get and update connection_status
	LOGD("Connection status updated, status: 0x%x", connection_status);
}


void update_recording_status()
{
	recording_state = RECORD_STATE_IDLE;
	record_state_t *recording_stat = &recording_state;
	// recording_state = gs_lv_transcode_get_state(hardware_info);  // doesnt work although a direct function is available in dji_glasses
	recording_state = ui_config->gs_lv_transcode_get_state(hardware_info);  // get and update recording_state
	LOGD("Recording status updated, status: 0x%x", recording_state);
}


void _ZN19GlassRacingChnlMenu7timeOutEv(void* this) {  // create returning function with an empty variable
	init();  // first initialize the library
	update_connection_status();
	#ifdef DEBUG
		update_recording_status();
	#endif

	LOGD("DEBUG:  gs_link_stat_t = %d, recording_flag = %d, recording_state = %d, record_mode = %d\n",
		connection_status,
		recording_flag,
		recording_state,
		ui_config->gs_lv_transcode_get_looping_mode(hardware_info));

	LOGD("DEBUG: libtp1801_gui_dji 0x%x, ui_config 0x%x, hardware_info 0x%x,  gs_modem_get_link_state_wrap 0x%x, libtp1801_timer 0x%x, libtp1801_settings 0x%x",
		libtp1801_gui_dji,
		ui_config,
		hardware_info,
		gs_modem_get_link_state_wrap,
		libtp1801_timer,
		libtp1801_settings);

	if (!recording_flag && (connection_status == GS_LINK_STAT_NORMAL))  // if flag is false and we have a normal link
	{
		recording_flag = true;  // set flag to true to indicate recording has started
		ui_config->gs_lv_transcode_record(hardware_info, true, RECORD_BUTTON);  // start recording
		LOGI("Recording has started\n");
	}
	else if (recording_flag && (connection_status == GS_LINK_STAT_LOST))  // if flag is true but we have lost link
	{
		recording_flag = false;  // set flag to false to indicate recording has stopped
		LOGI("Recording has stopped\n");
	}
	retrieve_timer(this);
	return;
}
