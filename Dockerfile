FROM hivaiot/ci-qt-windows-target:static as static

FROM hivaiot/ci-qt-windows-target:dynamic as dynamic

FROM debian:10

COPY --from=static / /

RUN rm /usr/bin/qmake

COPY --from=dynamic /mxe/usr/x86_64-w64-mingw32.shared /mxe/usr/x86_64-w64-mingw32.shared

RUN apt update && apt install jq

RUN wget https://github.com/QuasarApp/CQtDeployer/releases/download/1.5.4/CQtDeployer_1.5.4.0_Linux64.deb -O cqtdeployer.deb && \
    dpkg -i cqtdeployer.deb && \
    rm cqtdeployer.deb

RUN ln -s /mxe/usr/x86_64-w64-mingw32.shared/qt5/bin/qmake /usr/bin/qmake.shared

RUN ln -s /mxe/usr/x86_64-w64-mingw32.shared/qt5/bin/qmake /usr/bin/qmake.mingw64.shared

CMD /bin/bash

