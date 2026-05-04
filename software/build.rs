
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

    
    println!("cargo::rerun-if-changed=src/pico_lib.c");
    println!("cargo::rerun-if-changed=src/pico_lib.h");
    cc::Build::new()
        .file("src/pico_lib.c")
        .compile("pico_lib.a");
    

    bindings.write_to_file(bindings_file.clone()).expect(format!("Unable to write to {bindings_file}").as_str());
    
    println!("cargo::rerun-if-changed=build.rs");
}
