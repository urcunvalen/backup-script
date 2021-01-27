#!/bin/bash

#################################################################################
####### Backup de /home, /etc /root, fdisk, mbr et des packages installés #######
#################################################################################


DATE=$(date +%d-%m-%Y)
USER=""
BACKUP_DIR="/home/$USER/backups"


#####################
####### /home #######
#####################

#To create a new directory in the backup directory location
mkdir -p $BACKUP_DIR/$DATE

#To backup user's home directory
tar --exclude="$BACKUP_DIR" --exclude="/home/$USER/.cache" --exclude="home/$USER/.config"  --exclude="home/$USER/git-eisti" --exclude="home/$USER/Downloads" -zcvpf $BACKUP_DIR/$DATE/$USER-$DATE.tar.gz /home/$user


######################
####### config #######
######################

sudo tar -zcvpf $BACKUP_DIR/$DATE/config-$DATE.tar.gz /home/$USER/.config

####################
####### /etc #######
####################

sudo tar -zcvpf $BACKUP_DIR/$DATE/etc-$DATE.tar.gz /etc


#####################
####### /root #######
#####################

sudo tar -zcvpf $BACKUP_DIR/$DATE/root-$DATE.tar.gz /root


####################################
####### disk partition table #######
####################################

sudo fdisk -l > $BACKUP_DIR/$DATE/fdisk-$DATE.tar.gz


###################
####### mbr #######
###################

sudo dd if=/dev/sda of=$BACKUP_DIR/$DATE/MBR-$DATE.tar.gz bs=512 count=1
#sudo dd if=MBR.bak of=/dev/sda bs=512 count=1


########################
####### packages #######
########################

#List all installed packages
sudo dpkg --get-selections > $BACKUP_DIR/$DATE/packages-$DATE

#restore
#sudo dpkg --set-selections < packages
#sudo apt dselect-upgrade


#################################
####### clear old backups #######
#################################


find $BACKUP_DIR/* -mtime +10 -exec rm {} \;
