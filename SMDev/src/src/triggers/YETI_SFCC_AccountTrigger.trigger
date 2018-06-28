trigger YETI_SFCC_AccountTrigger on Account (before insert, before update, after insert, after update) {

    new YETI_SFCC_AccountHandler();
}