sed "s/Example stream name/$NAME/;                       \
     s/Example genre/$GENRE/;                            \
     s/A short description of your stream/$DESCRIPTION/; \
     s/localhost/icecast/;                               \
     s/hackme/$PASSWORD/;                                \
     s/example1.ogg/stream/;                             \
     s/64000/128000/;                                    \
     s/44100/48000/;                                     \
" < ices-2.0.2/conf/ices-playlist.xml > ices-playlist.xml
exec ices ices-playlist.xml
