require 'minitest/autorun'
require 'minitest/pride'
require 'curl_wrapper/config_options'

class CurlWrapperTest < MiniTest::Unit::TestCase
  class ConfigOptionsTest < MiniTest::Unit::TestCase
    KNOWN_LONG_CURL_OPTIONS = [
      { :method => :anyauth,                 :option => '--anyauth',                                                         :description => %q[Pick "any" authentication method (H)]                       },
      { :method => :append,                  :option => '--append',                                                          :description => %q[Append to target file when uploading (F/SFTP)]              },
      { :method => :basic,                   :option => '--basic',                                                           :description => %q[Use HTTP Basic Authentication (H)]                          },
      { :method => :cacert,                  :option => '--cacert',                  :param => 'FILE',                       :description => %q[CA certificate to verify peer against (SSL)]                },
      { :method => :capath,                  :option => '--capath',                  :param => 'DIR',                        :description => %q[CA directory to verify peer against (SSL)]                  },
      { :method => :cert,                    :option => '--cert',                    :param => 'CERT[:PASSWD]',              :description => %q[Client certificate file and password (SSL)]                 },
      { :method => :cert_type,               :option => '--cert-type',               :param => 'TYPE',                       :description => %q[Certificate file type (DER/PEM/ENG) (SSL)]                  },
      { :method => :ciphers,                 :option => '--ciphers',                 :param => 'LIST',                       :description => %q[SSL ciphers to use (SSL)]                                   },
      { :method => :compressed,              :option => '--compressed',                                                      :description => %q[Request compressed response (using deflate or gzip)]        },
      { :method => :config,                  :option => '--config',                  :param => 'FILE',                       :description => %q[Specify which config file to read]                          },
      { :method => :connect_timeout,         :option => '--connect-timeout',         :param => 'SECONDS',                    :description => %q[Maximum time allowed for connection]                        },
      { :method => :continue_at,             :option => '--continue-at',             :param => 'OFFSET',                     :description => %q[Resumed transfer offset]                                    },
      { :method => :cookie,                  :option => '--cookie',                  :param => 'STRING/FILE',                :description => %q[String or file to read cookies from (H)]                    },
      { :method => :cookie_jar,              :option => '--cookie-jar',              :param => 'FILE',                       :description => %q[Write cookies to this file after operation (H)]             },
      { :method => :create_dirs,             :option => '--create-dirs',                                                     :description => %q[Create necessary local directory hierarchy]                 },
      { :method => :crlf,                    :option => '--crlf',                                                            :description => %q[Convert LF to CRLF in upload]                               },
      { :method => :crlfile,                 :option => '--crlfile',                 :param => 'FILE',                       :description => %q[Get a CRL list in PEM format from the given file]           },
      { :method => :data,                    :option => '--data',                    :param => 'DATA',                       :description => %q[HTTP POST data (H)]                                         },
      { :method => :data_ascii,              :option => '--data-ascii',              :param => 'DATA',                       :description => %q[HTTP POST ASCII data (H)]                                   },
      { :method => :data_binary,             :option => '--data-binary',             :param => 'DATA',                       :description => %q[HTTP POST binary data (H)]                                  },
      { :method => :data_urlencode,          :option => '--data-urlencode',          :param => 'DATA',                       :description => %q[HTTP POST data url encoded (H)]                             },
      { :method => :delegation,              :option => '--delegation',              :param => 'STRING',                     :description => %q[GSS-API delegation permission]                              },
      { :method => :digest,                  :option => '--digest',                                                          :description => %q[Use HTTP Digest Authentication (H)]                         },
      { :method => :disable_eprt,            :option => '--disable-eprt',                                                    :description => %q[Inhibit using EPRT or LPRT (F)]                             },
      { :method => :disable_epsv,            :option => '--disable-epsv',                                                    :description => %q[Inhibit using EPSV (F)]                                     },
      { :method => :dump_header,             :option => '--dump-header',             :param => 'FILE',                       :description => %q[Write the headers to this file]                             },
      { :method => :egd_file,                :option => '--egd-file',                :param => 'FILE',                       :description => %q[EGD socket path for random data (SSL)]                      },
      { :method => :engine,                  :option => '--engine',                  :param => 'ENGINGE',                    :description => %q[Crypto engine (SSL). "--engine list" for list]              },
      { :method => :fail,                    :option => '--fail',                                                            :description => %q[Fail silently (no output at all) on HTTP errors (H)]        },
      { :method => :form,                    :option => '--form',                    :param => 'CONTENT',                    :description => %q[Specify HTTP multipart POST data (H)]                       },
      { :method => :form_string,             :option => '--form-string',             :param => 'STRING',                     :description => %q[Specify HTTP multipart POST data (H)]                       },
      { :method => :ftp_account,             :option => '--ftp-account',             :param => 'DATA',                       :description => %q[Account data string (F)]                                    },
      { :method => :ftp_alternative_to_user, :option => '--ftp-alternative-to-user', :param => 'COMMAND',                    :description => %q[String to replace "USER [name]" (F)]                        },
      { :method => :ftp_create_dirs,         :option => '--ftp-create-dirs',                                                 :description => %q[Create the remote dirs if not present (F)]                  },
      { :method => :ftp_method,              :option => '--ftp-method',              :param => '[MULTICWD/NOCWD/SINGLECWD]', :description => %q[Control CWD usage (F)]                                      },
      { :method => :ftp_pasv,                :option => '--ftp-pasv',                                                        :description => %q[Use PASV/EPSV instead of PORT (F)]                          },
      { :method => :ftp_port,                :option => '--ftp-port',                :param => 'ADR',                        :description => %q[Use PORT with given address instead of PASV (F)]            },
      { :method => :ftp_skip_pasv_ip,        :option => '--ftp-skip-pasv-ip',                                                :description => %q[Skip the IP address for PASV (F)]                           },
      { :method => :ftp_pret,                :option => '--ftp-pret',                                                        :description => %q[Send PRET before PASV (for drftpd) (F)]                     },
      { :method => :ftp_ssl_ccc,             :option => '--ftp-ssl-ccc',                                                     :description => %q[Send CCC after authenticating (F)]                          },
      { :method => :ftp_ssl_ccc_mode,        :option => '--ftp-ssl-ccc-mode',        :param => 'ACTIVE/PASSIVE',             :description => %q[Set CCC mode (F)]                                           },
      { :method => :ftp_ssl_control,         :option => '--ftp-ssl-control',                                                 :description => %q[Require SSL/TLS for ftp login, clear for transfer (F)]      },
      { :method => :get,                     :option => '--get',                                                             :description => %q[Send the -d data with a HTTP GET (H)]                       },
      { :method => :globoff,                 :option => '--globoff',                                                         :description => %q[Disable URL sequences and ranges using {} and []]           },
      { :method => :header,                  :option => '--header',                  :param => 'LINE',                       :description => %q[Custom header to pass to server (H)]                        },
      { :method => :head,                    :option => '--head',                                                            :description => %q[Show document info only]                                    },
      { :method => :help,                    :option => '--help',                                                            :description => %q[This help text]                                             },
      { :method => :hostpubmd5,              :option => '--hostpubmd5',              :param => 'MD5',                        :description => %q[Hex encoded MD5 string of the host public key. (SSH)]       },
      { :method => :http1_0,                 :option => '--http1.0',                                                         :description => %q[Use HTTP 1.0 (H)]                                           },
      { :method => :ignore_content_length,   :option => '--ignore-content-length',                                           :description => %q[Ignore the HTTP Content-Length header]                      },
      { :method => :include,                 :option => '--include',                                                         :description => %q[Include protocol headers in the output (H/F)]               },
      { :method => :insecure,                :option => '--insecure',                                                        :description => %q[Allow connections to SSL sites without certs (H)]           },
      { :method => :interface,               :option => '--interface',               :param => 'INTERFACE',                  :description => %q[Specify network interface/address to use]                   },
      { :method => :ipv4,                    :option => '--ipv4',                                                            :description => %q[Resolve name to IPv4 address]                               },
      { :method => :ipv6,                    :option => '--ipv6',                                                            :description => %q[Resolve name to IPv6 address]                               },
      { :method => :junk_session_cookies,    :option => '--junk-session-cookies',                                            :description => %q[Ignore session cookies read from file (H)]                  },
      { :method => :keepalive_time,          :option => '--keepalive-time',          :param => 'SECONDS',                    :description => %q[Interval between keepalive probes]                          },
      { :method => :key,                     :option => '--key',                     :param => 'KEY',                        :description => %q[Private key file name (SSL/SSH)]                            },
      { :method => :key_type,                :option => '--key-type',                :param => 'TYPE',                       :description => %q[Private key file type (DER/PEM/ENG) (SSL)]                  },
      { :method => :krb,                     :option => '--krb',                     :param => 'LEVEL',                      :description => %q[Enable Kerberos with specified security level (F)]          },
      { :method => :libcurl,                 :option => '--libcurl',                 :param => 'FILE',                       :description => %q[Dump libcurl equivalent code of this command line]          },
      { :method => :limit_rate,              :option => '--limit-rate',              :param => 'RATE',                       :description => %q[Limit transfer speed to this rate]                          },
      { :method => :list_only,               :option => '--list-only',                                                       :description => %q[List only names of an FTP directory (F)]                    },
      { :method => :local_port,              :option => '--local-port',              :param => 'RANGE',                      :description => %q[Force use of these local port numbers]                      },
      { :method => :location,                :option => '--location',                                                        :description => %q[Follow redirects (H)]                                       },
      { :method => :location_trusted,        :option => '--location-trusted',                                                :description => %q[like --location and send auth to other hosts (H)]           },
      { :method => :manual,                  :option => '--manual',                                                          :description => %q[Display the full manual]                                    },
      { :method => :mail_from,               :option => '--mail-from',               :param => 'FROM',                       :description => %q[Mail from this address]                                     },
      { :method => :mail_rcpt,               :option => '--mail-rcpt',               :param => 'TO',                         :description => %q[Mail to this receiver(s)]                                   },
      { :method => :max_filesize,            :option => '--max-filesize',            :param => 'BYTES',                      :description => %q[Maximum file size to download (H/F)]                        },
      { :method => :max_redirs,              :option => '--max-redirs',              :param => 'NUM',                        :description => %q[Maximum number of redirects allowed (H)]                    },
      { :method => :max_time,                :option => '--max-time',                :param => 'SECONDS',                    :description => %q[Maximum time allowed for the transfer]                      },
      { :method => :negotiate,               :option => '--negotiate',                                                       :description => %q[Use HTTP Negotiate Authentication (H)]                      },
      { :method => :netrc,                   :option => '--netrc',                                                           :description => %q[Must read .netrc for user name and password]                },
      { :method => :netrc_optional,          :option => '--netrc-optional',                                                  :description => %q[Use either .netrc or URL; overrides -n]                     },
      { :method => :netrc_file,              :option => '--netrc-file',              :param => 'FILE',                       :description => %q[Set up the netrc filename to use]                           },
      { :method => :no_buffer,               :option => '--no-buffer',                                                       :description => %q[Disable buffering of the output stream]                     },
      { :method => :no_keepalive,            :option => '--no-keepalive',                                                    :description => %q[Disable keepalive use on the connection]                    },
      { :method => :no_sessionid,            :option => '--no-sessionid',                                                    :description => %q[Disable SSL session-ID reusing (SSL)]                       },
      { :method => :noproxy,                 :option => '--noproxy',                                                         :description => %q[List of hosts which do not use proxy]                       },
      { :method => :ntlm,                    :option => '--ntlm',                                                            :description => %q[Use HTTP NTLM authentication (H)]                           },
      { :method => :output,                  :option => '--output',                  :param => 'FILE',                       :description => %q[Write output to <file> instead of stdout]                   },
      { :method => :pass,                    :option => '--pass',                    :param => 'PASS',                       :description => %q[Pass phrase for the private key (SSL/SSH)]                  },
      { :method => :post301,                 :option => '--post301',                                                         :description => %q[Do not switch to GET after following a 301 redirect (H)]    },
      { :method => :post302,                 :option => '--post302',                                                         :description => %q[Do not switch to GET after following a 302 redirect (H)]    },
      { :method => :progress_bar,            :option => '--progress-bar',                                                    :description => %q[Display transfer progress as a progress bar]                },
      { :method => :proto,                   :option => '--proto',                   :param => 'PROTOCOLS',                  :description => %q[Enable/disable specified protocols]                         },
      { :method => :proto_redir,             :option => '--proto-redir',             :param => 'PROTOCOLS',                  :description => %q[Enable/disable specified protocols on redirect]             },
      { :method => :proxy,                   :option => '--proxy',                   :param => '[PROTOCOL://]HOST[:PORT]',   :description => %q[Use proxy on given port]                                    },
      { :method => :proxy_anyauth,           :option => '--proxy-anyauth',                                                   :description => %q[Pick "any" proxy authentication method (H)]                 },
      { :method => :proxy_basic,             :option => '--proxy-basic',                                                     :description => %q[Use Basic authentication on the proxy (H)]                  },
      { :method => :proxy_digest,            :option => '--proxy-digest',                                                    :description => %q[Use Digest authentication on the proxy (H)]                 },
      { :method => :proxy_negotiate,         :option => '--proxy-negotiate',                                                 :description => %q[Use Negotiate authentication on the proxy (H)]              },
      { :method => :proxy_ntlm,              :option => '--proxy-ntlm',                                                      :description => %q[Use NTLM authentication on the proxy (H)]                   },
      { :method => :proxy_user,              :option => '--proxy-user',              :param => 'USER[:PASSWORD]',            :description => %q[Proxy user and password]                                    },
      { :method => :proxy1_0,                :option => '--proxy1.0',                :param => 'HOST[:PORT]',                :description => %q[Use HTTP/1.0 proxy on given port]                           },
      { :method => :proxytunnel,             :option => '--proxytunnel',                                                     :description => %q[Operate through a HTTP proxy tunnel (using CONNECT)]        },
      { :method => :pubkey,                  :option => '--pubkey',                  :param => 'KEY',                        :description => %q[Public key file name (SSH)]                                 },
      { :method => :quote,                   :option => '--quote',                   :param => 'CMD',                        :description => %q[Send command(s) to server before transfer (F/SFTP)]         },
      { :method => :random_file,             :option => '--random-file',             :param => 'FILE',                       :description => %q[File for reading random data from (SSL)]                    },
      { :method => :range,                   :option => '--range',                   :param => 'RANGE',                      :description => %q[Retrieve only the bytes within a range]                     },
      { :method => :raw,                     :option => '--raw',                                                             :description => %q[Do HTTP "raw", without any transfer decoding (H)]           },
      { :method => :referer,                 :option => '--referer',                                                         :description => %q[Referer URL (H)]                                            },
      { :method => :remote_header_name,      :option => '--remote-header-name',                                              :description => %q[Use the header-provided filename (H)]                       },
      { :method => :remote_name,             :option => '--remote-name',                                                     :description => %q[Write output to a file named as the remote file]            },
      { :method => :remote_name_all,         :option => '--remote-name-all',                                                 :description => %q[Use the remote file name for all URLs]                      },
      { :method => :remote_time,             :option => '--remote-time',                                                     :description => %q[Set the remote file's time on the local output]             },
      { :method => :request,                 :option => '--request',                 :param => 'COMMAND',                    :description => %q[Specify request command to use]                             },
      { :method => :resolve,                 :option => '--resolve',                 :param => 'HOST:PORT:ADDRESS',          :description => %q[Force resolve of HOST:PORT to ADDRESS]                      },
      { :method => :retry,                   :option => '--retry',                   :param => 'NUM',                        :description => %q[Retry request NUM times if transient problems occur]        },
      { :method => :retry_delay,             :option => '--retry-delay',             :param => 'SECONDS',                    :description => %q[When retrying, wait this many seconds between each]         },
      { :method => :retry_max_time,          :option => '--retry-max-time',          :param => 'SECONDS',                    :description => %q[Retry only within this period]                              },
      { :method => :show_error,              :option => '--show-error',                                                      :description => %q[Show error. With -s, make curl show errors when they occur] },
      { :method => :silent,                  :option => '--silent',                                                          :description => %q[Silent mode. Don't output anything]                         },
      { :method => :socks4,                  :option => '--socks4',                  :param => 'HOST[:PORT]',                :description => %q[SOCKS4 proxy on given host + port]                          },
      { :method => :socks4a,                 :option => '--socks4a',                 :param => 'HOST[:PORT]',                :description => %q[SOCKS4a proxy on given host + port]                         },
      { :method => :socks5,                  :option => '--socks5',                  :param => 'HOST[:PORT]',                :description => %q[SOCKS5 proxy on given host + port]                          },
      { :method => :socks5_hostname,         :option => '--socks5-hostname',         :param => 'HOST[:PORT]',                :description => %q[SOCKS5 proxy, pass host name to proxy]                      },
      { :method => :speed_limit,             :option => '--speed-limit',             :param => 'RATE',                       :description => %q[Stop transfers below speed-limit for 'speed-time' secs]     },
      { :method => :speed_time,              :option => '--speed-time',              :param => 'SECONDS',                    :description => %q[Time for trig speed-limit abort. Defaults to 30]            },
      { :method => :ssl,                     :option => '--ssl',                                                             :description => %q[Try SSL/TLS (FTP, IMAP, POP3, SMTP)]                        },
      { :method => :ssl_reqd,                :option => '--ssl-reqd',                                                        :description => %q[Require SSL/TLS (FTP, IMAP, POP3, SMTP)]                    },
      { :method => :sslv2,                   :option => '--sslv2',                                                           :description => %q[Use SSLv2 (SSL)]                                            },
      { :method => :sslv3,                   :option => '--sslv3',                                                           :description => %q[Use SSLv3 (SSL)]                                            },
      { :method => :stderr,                  :option => '--stderr',                  :param => 'FILE',                       :description => %q[Where to redirect stderr. - means stdout]                   },
      { :method => :tcp_nodelay,             :option => '--tcp-nodelay',                                                     :description => %q[Use the TCP_NODELAY option]                                 },
      { :method => :telnet_option,           :option => '--telnet-option',           :param => 'OPT=VAL',                    :description => %q[Set telnet option]                                          },
      { :method => :tftp_blksize,            :option => '--tftp-blksize',            :param => 'VALUE',                      :description => %q[Set TFTP BLKSIZE option (must be >512)]                     },
      { :method => :time_cond,               :option => '--time-cond',               :param => 'TIME',                       :description => %q[Transfer based on a time condition]                         },
      { :method => :tlsv1,                   :option => '--tlsv1',                                                           :description => %q[Use TLSv1 (SSL)]                                            },
      { :method => :trace,                   :option => '--trace',                   :param => 'FILE',                       :description => %q[Write a debug trace to the given file]                      },
      { :method => :trace_ascii,             :option => '--trace-ascii',             :param => 'FILE',                       :description => %q[Like --trace but without the hex output]                    },
      { :method => :trace_time,              :option => '--trace-time',                                                      :description => %q[Add time stamps to trace/verbose output]                    },
      { :method => :tr_encoding,             :option => '--tr-encoding',                                                     :description => %q[Request compressed transfer encoding (H)]                   },
      { :method => :upload_file,             :option => '--upload-file',             :param => 'FILE',                       :description => %q[Transfer FILE to destination]                               },
      { :method => :url,                     :option => '--url',                     :param => 'URL',                        :description => %q[URL to work with]                                           },
      { :method => :use_ascii,               :option => '--use-ascii',                                                       :description => %q[Use ASCII/text transfer]                                    },
      { :method => :user,                    :option => '--user',                    :param => 'USER[:PASSWORD]',            :description => %q[Server user and password]                                   },
      { :method => :tlsuser,                 :option => '--tlsuser',                 :param => 'USER',                       :description => %q[TLS username]                                               },
      { :method => :tlspassword,             :option => '--tlspassword',             :param => 'STRING',                     :description => %q[TLS password]                                               },
      { :method => :tlsauthtype,             :option => '--tlsauthtype',             :param => 'STRING',                     :description => %q[TLS authentication type (default SRP)]                      },
      { :method => :user_agent,              :option => '--user-agent',              :param => 'STRING',                     :description => %q[User-Agent to send to server (H)]                           },
      { :method => :verbose,                 :option => '--verbose',                                                         :description => %q[Make the operation more talkative]                          },
      { :method => :version,                 :option => '--version',                                                         :description => %q[Show version number and quit]                               },
      { :method => :write_out,               :option => '--write-out',               :param => 'FORMAT',                     :description => %q[What to output after completion]                            },
      { :method => :xattr,                   :option => '--xattr',                                                           :description => %q[Store metadata in extended file attributes]                 },
    ]

    KNOWN_SHORT_CURL_OPTIONS = [
      { :method => :a,   :option => '-a',                                       :description => %q[Append to target file when uploading (F/SFTP)]              },
      { :method => :E,   :option => '-E', :param => 'CERT[:PASSWD]',            :description => %q[Client certificate file and password (SSL)]                 },
      { :method => :K,   :option => '-K', :param => 'FILE',                     :description => %q[Specify which config file to read]                          },
      { :method => :C,   :option => '-C', :param => 'OFFSET',                   :description => %q[Resumed transfer offset]                                    },
      { :method => :b,   :option => '-b', :param => 'STRING/FILE',              :description => %q[String or file to read cookies from (H)]                    },
      { :method => :c,   :option => '-c', :param => 'FILE',                     :description => %q[Write cookies to this file after operation (H)]             },
      { :method => :d,   :option => '-d', :param => 'DATA',                     :description => %q[HTTP POST data (H)]                                         },
      { :method => :D,   :option => '-D', :param => 'FILE',                     :description => %q[Write the headers to this file]                             },
      { :method => :f,   :option => '-f',                                       :description => %q[Fail silently (no output at all) on HTTP errors (H)]        },
      { :method => :F,   :option => '-F', :param => 'CONTENT',                  :description => %q[Specify HTTP multipart POST data (H)]                       },
      { :method => :P,   :option => '-P', :param => 'ADR',                      :description => %q[Use PORT with given address instead of PASV (F)]            },
      { :method => :G,   :option => '-G',                                       :description => %q[Send the -d data with a HTTP GET (H)]                       },
      { :method => :g,   :option => '-g',                                       :description => %q[Disable URL sequences and ranges using {} and []]           },
      { :method => :H,   :option => '-H', :param => 'LINE',                     :description => %q[Custom header to pass to server (H)]                        },
      { :method => :I,   :option => '-I',                                       :description => %q[Show document info only]                                    },
      { :method => :h,   :option => '-h',                                       :description => %q[This help text]                                             },
      { :method => :'0', :option => '-0',                                       :description => %q[Use HTTP 1.0 (H)]                                           },
      { :method => :i,   :option => '-i',                                       :description => %q[Include protocol headers in the output (H/F)]               },
      { :method => :k,   :option => '-k',                                       :description => %q[Allow connections to SSL sites without certs (H)]           },
      { :method => :'4', :option => '-4',                                       :description => %q[Resolve name to IPv4 address]                               },
      { :method => :'6', :option => '-6',                                       :description => %q[Resolve name to IPv6 address]                               },
      { :method => :j,   :option => '-j',                                       :description => %q[Ignore session cookies read from file (H)]                  },
      { :method => :l,   :option => '-l',                                       :description => %q[List only names of an FTP directory (F)]                    },
      { :method => :L,   :option => '-L',                                       :description => %q[Follow redirects (H)]                                       },
      { :method => :M,   :option => '-M',                                       :description => %q[Display the full manual]                                    },
      { :method => :m,   :option => '-m', :param => 'SECONDS',                  :description => %q[Maximum time allowed for the transfer]                      },
      { :method => :n,   :option => '-n',                                       :description => %q[Must read .netrc for user name and password]                },
      { :method => :N,   :option => '-N',                                       :description => %q[Disable buffering of the output stream]                     },
      { :method => :o,   :option => '-o', :param => 'FILE',                     :description => %q[Write output to <file> instead of stdout]                   },
      { :method => :'#', :option => '-#',                                       :description => %q[Display transfer progress as a progress bar]                },
      { :method => :x,   :option => '-x', :param => '[PROTOCOL://]HOST[:PORT]', :description => %q[Use proxy on given port]                                    },
      { :method => :U,   :option => '-U', :param => 'USER[:PASSWORD]',          :description => %q[Proxy user and password]                                    },
      { :method => :p,   :option => '-p',                                       :description => %q[Operate through a HTTP proxy tunnel (using CONNECT)]        },
      { :method => :Q,   :option => '-Q', :param => 'CMD',                      :description => %q[Send command(s) to server before transfer (F/SFTP)]         },
      { :method => :r,   :option => '-r', :param => 'RANGE',                    :description => %q[Retrieve only the bytes within a range]                     },
      { :method => :e,   :option => '-e',                                       :description => %q[Referer URL (H)]                                            },
      { :method => :J,   :option => '-J',                                       :description => %q[Use the header-provided filename (H)]                       },
      { :method => :O,   :option => '-O',                                       :description => %q[Write output to a file named as the remote file]            },
      { :method => :R,   :option => '-R',                                       :description => %q[Set the remote file's time on the local output]             },
      { :method => :X,   :option => '-X', :param => 'COMMAND',                  :description => %q[Specify request command to use]                             },
      { :method => :S,   :option => '-S',                                       :description => %q[Show error. With -s, make curl show errors when they occur] },
      { :method => :s,   :option => '-s',                                       :description => %q[Silent mode. Don't output anything]                         },
      { :method => :Y,   :option => '-Y', :param => 'RATE',                     :description => %q[Stop transfers below speed-limit for 'speed-time' secs]     },
      { :method => :y,   :option => '-y', :param => 'SECONDS',                  :description => %q[Time for trig speed-limit abort. Defaults to 30]            },
      { :method => :'2', :option => '-2',                                       :description => %q[Use SSLv2 (SSL)]                                            },
      { :method => :'3', :option => '-3',                                       :description => %q[Use SSLv3 (SSL)]                                            },
      { :method => :t,   :option => '-t', :param => 'OPT=VAL',                  :description => %q[Set telnet option]                                          },
      { :method => :z,   :option => '-z', :param => 'TIME',                     :description => %q[Transfer based on a time condition]                         },
      { :method => :'1', :option => '-1',                                       :description => %q[Use TLSv1 (SSL)]                                            },
      { :method => :T,   :option => '-T', :param => 'FILE',                     :description => %q[Transfer FILE to destination]                               },
      { :method => :B,   :option => '-B',                                       :description => %q[Use ASCII/text transfer]                                    },
      { :method => :u,   :option => '-u', :param => 'USER[:PASSWORD]',          :description => %q[Server user and password]                                   },
      { :method => :A,   :option => '-A', :param => 'STRING',                   :description => %q[User-Agent to send to server (H)]                           },
      { :method => :v,   :option => '-v',                                       :description => %q[Make the operation more talkative]                          },
      { :method => :V,   :option => '-V',                                       :description => %q[Show version number and quit]                               },
      { :method => :w,   :option => '-w', :param => 'FORMAT',                   :description => %q[What to output after completion]                            },
      { :method => :q,   :option => '-q',                                       :description => %q[If used as the first parameter disables .curlrc]            },
    ]

    class CurlWrapperFack
      include CurlWrapper::ConfigOptions
    end

    def test_known_long_curl_options
      KNOWN_LONG_CURL_OPTIONS.each do |long_option|
        curl = CurlWrapperFack.new
        if long_option[:param].nil?
          curl.send long_option[:method]
          expected = "#{long_option[:option]}"
          assert_equal expected, curl.options, "Should have worked for #{expected} => '#{long_option[:description]}'"
        else
          curl.send long_option[:method], long_option[:param]
          expected = "#{long_option[:option]} '#{long_option[:param]}'"
          assert_equal expected, curl.options, "Should have worked for #{expected} => '#{long_option[:description]}'"
        end
      end
    end

    def test_known_short_curl_options
      KNOWN_SHORT_CURL_OPTIONS.each do |short_option|
        curl = CurlWrapperFack.new
        if short_option[:param].nil?
          curl.send short_option[:method]
          expected = "#{short_option[:option]}"
          assert_equal expected, curl.options, "Should have worked for #{expected} => '#{short_option[:description]}'"
        else
          curl.send short_option[:method], short_option[:param]
          expected = "#{short_option[:option]} '#{short_option[:param]}'"
          assert_equal expected, curl.options, "Should have worked for #{expected} => '#{short_option[:description]}'"
        end
      end
    end

    def test_combinde_options
     long_option = KNOWN_LONG_CURL_OPTIONS[30]
     short_option = KNOWN_SHORT_CURL_OPTIONS[9]

     curl = CurlWrapperFack.new

     if short_option[:param].nil?
       curl.send short_option[:method]
       expected_short = "#{short_option[:option]}"
     else
       curl.send short_option[:method], short_option[:param]
       expected_short = "#{short_option[:option]} '#{short_option[:param]}'"
     end

     if long_option[:param].nil?
       curl.send long_option[:method]
       expected_long = "#{long_option[:option]}"
     else
       curl.send long_option[:method], long_option[:param]
       expected_long = "#{long_option[:option]} '#{long_option[:param]}'"
     end
     expected = [expected_short, expected_long].join(' ')

     assert_equal expected, curl.options, "Should have worked for #{expected} => '#{short_option[:description]}' and '#{long_option[:description]}'"
    end


    def test_known_long_curl_options_returns_self
      KNOWN_LONG_CURL_OPTIONS.each do |long_option|
        actual_return_value = nil
        curl = CurlWrapperFack.new
        if long_option[:param].nil?
          actual_return_value = curl.send long_option[:method]
        else
          actual_return_value = curl.send long_option[:method], long_option[:param]
        end

        assert_equal curl, actual_return_value, "Should be returning self to enable changing."
      end
    end

    def test_known_short_curl_options_returns_self
      KNOWN_SHORT_CURL_OPTIONS.each do |short_option|
        actual_return_value = nil
        curl = CurlWrapperFack.new
        if short_option[:param].nil?
          actual_return_value = curl.send short_option[:method]
        else
          actual_return_value = curl.send short_option[:method], short_option[:param]
        end

        assert_equal curl, actual_return_value, "Should be returning self to enable changing."
      end
    end

  end
end
