require 'ffi'

module SHMTools
  extend FFI::Library
  ffi_lib FFI::Library::LIBC

# struct ipc_perm {
#      key_t          __key;    /* Key supplied to shmget(2) */
#      uid_t          uid;      /* Effective UID of owner */
#      gid_t          gid;      /* Effective GID of owner */
#      uid_t          cuid;     /* Effective UID of creator */
#      gid_t          cgid;     /* Effective GID of creator */
#      unsigned short mode;     /* Permissions + SHM_DEST and
#                                  SHM_LOCKED flags */
#      unsigned short int __pad1;
#      unsigned short __seq;    /* Sequence number */
#      unsigned short int __pad2;
#      unsigned long int __unused1;
#      unsigned long int __unused2;
# };

  class IPCPerm < FFI::Struct
    layout \
    :key, :__key_t, \
    :uid, :__uid_t, \
    :gid, :__gid_t, \
    :cuid, :__uid_t, \
    :cgid, :__gid_t, \
    :mode, :ushort, \
    :__pad1, :ushort, \
    :seq, :ushort, \
    :__pad2, :ushort, \
    :__unused1, :ulong, \
    :__unused2, :ulong
  end

# struct shmid_ds {
#     struct ipc_perm shm_perm;    /* Ownership and permissions */
#     size_t          shm_segsz;   /* Size of segment (bytes) */
#     time_t          shm_atime;   /* Last attach time */
#     time_t          shm_dtime;   /* Last detach time */
#     time_t          shm_ctime;   /* Last change time */
#     pid_t           shm_cpid;    /* PID of creator */
#     pid_t           shm_lpid;    /* PID of last shmat(2)/shmdt(2) */
#     shmatt_t        shm_nattch;  /* No. of current attaches */
#     unsigned long int __unused4;
#     unsigned long int __unused5;
# };

  class SHMIDDs < FFI::Struct
    layout \
    :perm, IPCPerm, \
    :segsz, :size_t, \
    :atime, :time_t, \
    :dtime, :time_t, \
    :ctime, :time_t, \
    :cpid, :__pid_t, \
    :lpid, :__pid_t, \
    :nattch, :ulong, \
    :__unused4, :ulong, \
    :__unused5, :ulong
  end

#  struct shm_info {
#      int           used_ids; /* # of currently existing segments */
#      unsigned long shm_tot;  /* Total number of shared memory pages */
#      unsigned long shm_rss;  /* # of resident shared memory pages */
#      unsigned long shm_swp;  /* # of swapped shared memory pages */
#      unsigned long swap_attempts;  /* Unused since Linux 2.4 */
#      unsigned long swap_successes; /* Unused since Linux 2.4 */
#  };

  class SHM_Info < FFI::Struct
    layout \
    :used_ids, :int, \
    :tot, :ulong, \
    :rss, :ulong, \
    :swp, :ulong, \
    :swap_attempts, :ulong, \
    :swap_successes, :ulong
  end

  attach_function :shmctl, [:int, :int, :pointer], :int

  SHM_LOCK = 11
  SHM_UNLOCK = 12
  SHM_STAT = 13
  SHM_INFO = 14

  class SHMError < StandardError; end

  def self.shmctl_info
    shm_info = SHM_Info.new
    res = shmctl(0, SHM_INFO, shm_info)
    raise SHMError, "shmctl(SHM_INFO) blew up with #{FFI::errno}" if res < 0
    return res, shm_info
  end

  def self.used_ids
    _, shm_info = shmctl_info
    shm_info[:used_ids]
  end

  StatTuple = Struct.new :id, :ds

  def self.shm_stat(id)
    shmid_ds = SHMIDDs.new
    res = shmctl(id, SHM_STAT, shmid_ds)
    raise SHMError, "shmctl(SHM_STAT) blew up with #{FFI::errno}" if res < 0
    StatTuple[ res, shmid_ds ]
  end

  def self.all_shmid_dses
    (0...used_ids).map { |id| shm_stat(id) }
  end

  def self.shmids_for_uid(uid)
    all_shmid_dses.select{ |e| e.ds[:perm][:uid] == uid }.map { |e| e.id }
  end

  def self.shm_lock(id)
    shmid_ds = SHMIDDs.new
    res = shmctl(id, SHM_LOCK, shmid_ds)
    raise SHMError, "shmctl(SHM_LOCK) blew up with #{FFI::errno}" if res < 0
    res
  end

  def self.shm_unlock(id)
    shmid_ds = SHMIDDs.new
    res = shmctl(id, SHM_UNLOCK, shmid_ds)
    raise SHMError, "shmctl(SHM_LOCK) blew up with #{FFI::errno}" if res < 0
    res
  end

end
