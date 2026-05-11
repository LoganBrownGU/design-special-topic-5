fn main() {
    println!("cargo:rustc-link-search=/opt/picoscope/lib/");
    println!("cargo:rustc-link-lib=ps2000");

    
    println!("cargo::rerun-if-changed=bindings.h");
    let bindings_file = std::env::var("OUT_DIR").unwrap() + "/bindings.rs";
    let bindings = bindgen::Builder::default()
        .header("bindings.h")
        .parse_callbacks(Box::new(bindgen::CargoCallbacks::new()))
        .generate()
        .expect("Could not generate Picoscope bindings.");

    /*
    let f = File::open(bindings_file).unwrap();
    let mut writer = BufWriter::new(f);
    writer.write(b"\
        #![allow(non_upper_case_globals)]
        #![allow(non_camel_case_types)]
        #![allow(non_snake_case)]
    ").unwrap();
    bindings.write(Box::new(writer)).unwrap();*/
    bindings.write_to_file(bindings_file.clone()).expect(format!("Unable to write to {bindings_file}").as_str());

    
    println!("cargo::rerun-if-changed=src/pico_lib.c");
    println!("cargo::rerun-if-changed=src/pico_lib.h");
    cc::Build::new()
        .file("src/pico_lib.c")
        .compile("pico_lib.a");
    

    
    println!("cargo::rerun-if-changed=build.rs");
}
